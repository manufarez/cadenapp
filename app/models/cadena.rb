class Cadena < ApplicationRecord
  has_many :participations, dependent: :nullify
  has_many :invitations, dependent: :destroy
  has_many :users, through: :participations
  has_many :installments, dependent: :destroy
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
    participations.find_by(is_admin: true)&.user
  end

  def missing_participants
    desired_participants - participations.count
  end

  def participation_status
    missing_participants.positive? ? "#{participations.count}/#{desired_participants}" : participations.count
  end

  def set_saving_goal
    return 0 unless installments.any? && installment_value

    self.saving_goal = desired_installments * installment_value
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

  def calculate_withdrawal_dates
    periodicity_multiplier = periodicity == 'monthly' ? 30 : 15

    participations.order(:position).each_with_index(1) do |participation, index|
      withdrawal_date = start_date + (index * periodicity_multiplier).day
      participation.update(withdrawal_day: withdrawal_date)
    end
  end

  def next_payment_day(current_date)
    withdrawal_dates = participations.pluck(:withdrawal_day).compact.select { |date| date >= current_date }
    withdrawal_dates.min.strftime('%d/%m/%y') || nil
  end

  def participants
    participations.includes(:user).map { |participation| "#{participation.user.first_name} #{participation.user.last_name}" }
  end
end
