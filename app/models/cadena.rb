class Cadena < ApplicationRecord
  has_many :participants, dependent: :nullify
  has_many :invitations, dependent: :destroy
  has_many :users, through: :participants
  before_save :set_status, :set_saving_goal
  enum status: {
         pending: 'pending',
         complete: 'complete',
         approval_requested: 'approval_requested',
         started: 'started',
         stopped: 'stopped',
         over: 'over',
         archived: 'archived'
       },
       _default: 'pending'
  enum periodicity: { bimonthly: 'bimonthly', monthly: 'monthly' }, _default: 'monthly'

  def admin
    participants.find_by(is_admin: true)&.user
  end

  def participants_names
    participants.includes(:user).map { |participant| "#{participant.user.first_name} #{participant.user.last_name}" }
  end

  def participant_status
    missing_participants.positive? ? "#{participants.count}/#{desired_participants}" : participants.count
  end

  def missing_participants
    desired_participants - participants.count
  end

  def set_saving_goal
    self.saving_goal = desired_installments * installment_value
  end

  def status_color
    status_colors = {
      'complete' => 'text-primary_blue border-blue-600',
      'pending' => 'text-pinky border-pinky',
      'approval_requested' => 'text-mayo border-mayo',
      'started' => 'text-ciel border-ciel',
      'stopped' => 'text-red-500 border-red-500'
    }
    status_colors[status] || ''
  end

  def set_status
    self.status = if missing_participants.positive?
                    "pending"
                  elsif missing_participants.zero? && !approval_requested && !positions_assigned
                    "complete"
                  elsif missing_participants.zero? && approval_requested && !positions_assigned
                    "approval_requested"
                  elsif missing_participants.zero? && approval_requested && positions_assigned
                    "started"
                  end
  end

  def calculate_withdrawal_dates
    periodicity_multiplier = periodicity == 'monthly' ? 30 : 15

    participants.order(:position).each.with_index(1) do |participant, index|
      participant.update(
        withdrawal_day: start_date + (index * periodicity_multiplier).day,
        payments_expected: desired_installments - 1,
        total_due: saving_goal - installment_value
      )
    end
  end

  def assign_positions
    participants.shuffle.each.with_index(1) do |participant, index|
      participant.update(position: index)
    end
    calculate_withdrawal_dates
    update(status: 'started', positions_assigned: true)
  end

  def next_payment_day(current_date)
    withdrawal_dates = participants.pluck(:withdrawal_day).compact.select { |date| date >= current_date }
    withdrawal_dates.min.strftime('%d/%m/%y') || nil
  end

  def next_paid_participant(current_date)
    participants.where('withdrawal_day >= ?', current_date).min_by(&:withdrawal_day)
  end
end
