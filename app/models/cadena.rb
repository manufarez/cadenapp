class Cadena < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :users, through: :participants
  has_many :payments, dependent: :destroy
  before_save :set_status, :set_saving_goal
  validates :desired_participants, presence: true
  validates :desired_installments, presence: true
  validates :name, presence: true
  validates :periodicity, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :saving_goal, presence: true
  validates :installment_value, presence: true
  validates :accepts_admin_terms, acceptance: { message: "You must accept the admin terms" }
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
    participants.includes(:user).map(&:name)
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

  def next_payment_day(global_date)
    return unless started?

    withdrawal_dates = participants.pluck(:withdrawal_day).compact.select { |date| date >= global_date }
    withdrawal_dates.min || nil
  end

  def days_to_payment(global_date)
    return unless started?

    (next_payment_day(global_date) - global_date).to_i
  end

  def next_paid_participant(global_date)
    participants.where('withdrawal_day >= ?', global_date).min_by(&:withdrawal_day)
  end

  def participants_except_next_paid(global_date)
    next_participant = next_paid_participant(global_date)
    participants.where.not(id: next_participant.id)
  end

  def unpaid_turn_participants(global_date)
    next_participant = next_paid_participant(global_date)
    return unless next_participant

    participants.reject do |user|
      user.paid_next_participant?(self, global_date)
    end
  end

  def period_ratio(global_date)
    "#{next_paid_participant(global_date).payments_received}/#{next_paid_participant(global_date).payments_expected}"
  end

  def period_progression(global_date)
    return "N/A" unless started?

    received = next_paid_participant(global_date).payments_received
    expected = next_paid_participant(global_date).payments_expected.to_f
    (received / expected * 100).round(0)
  end

  def global_progression
    return "N/A" unless started?

    received = participants.where(payments_received: desired_installments - 1).count
    expected = participants.count.to_f
    (received / expected * 100).round(0)
  end
end
