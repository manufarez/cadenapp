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
         participants_approval: 'participants_approval',
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
      'complete' => 'text-ciel border-ciel',
      'pending' => 'text-pinky border-pinky',
      'participants_approval' => 'text-mayo border-mayo',
      'started' => 'text-primary_blue border-blue-600',
      'stopped' => 'text-red-500 border-red-500'
    }
    status_colors[status] || ''
  end

  def set_status
    self.status = if missing_participants.positive?
                    "pending"
                  elsif missing_participants.zero? && !participants_approval && !positions_assigned
                    "complete"
                  elsif missing_participants.zero? && participants_approval && !positions_assigned
                    "participants_approval"
                  elsif missing_participants.zero? && participants_approval && positions_assigned
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

  def next_payment_date
    return unless started?

    withdrawal_dates = participants.pluck(:withdrawal_day).compact.select { |date| date >= Time.zone.now }
    withdrawal_dates.min || nil
  end

  # def subsequent_payment_date
  #   next_payment_date + 1.day
  # end

  def days_to_payment
    return unless started?

    (next_payment_date - Time.zone.now.to_date).to_i
  end

  def next_paid_participant
    participants.where('withdrawal_day >= ?', Time.zone.now).min_by(&:withdrawal_day)
  end

  def participants_except_next_paid
    participants.where.not(id: next_paid_participant.id)
  end

  def unpaid_turn_participants
    return unless next_paid_participant

    participants.reject { |user| user.paid_next_participant?(self) }
  end

  def period_ratio
    "#{next_paid_participant.payments_received}/#{next_paid_participant.payments_expected}"
  end

  def period_progression
    return "N/A" unless started?

    received = next_paid_participant.payments_received
    expected = next_paid_participant.payments_expected.to_f
    (received / expected * 100).round(0)
  end

  def global_progression
    return "N/A" unless started?

    received = participants.where(payments_received: desired_installments - 1).count
    expected = participants.count.to_f
    (received / expected * 100).round(0)
  end
end
