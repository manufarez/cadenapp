class Cadena < ApplicationRecord
  has_one :admin, class_name: 'Participant', dependent: :destroy
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
  validates :saving_goal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :installment_value, presence: true
  validates :accepts_admin_terms, acceptance: { message: 'You must accept the admin terms' }
  validate :start_date_is_future
  validate :end_date_matches_installments
  validate :installments_match_participants
  enum status: { pending: 'pending', complete: 'complete',
                 participants_approval: 'participants_approval',
                 started: 'started', stopped: 'stopped', over: 'over',
                 archived: 'archived' },
       _default: 'pending'
  enum periodicity: { daily: 'daily', bimonthly: 'bimonthly', monthly: 'monthly' }, _default: 'monthly'

  def start_date_is_future
    if start_date.present? && start_date <= Time.zone.now
      errors.add(:start_date, "(#{start_date.strftime('%d/%m/%Y')}) should be in the future")
    end
    errors.empty?
  end

  def end_date_matches_installments
    if periodicity == 'daily' && end_date != start_date + desired_installments.days
      errors.add(:end_date, "does not match number of remaining days")
    elsif periodicity == 'monthly' && end_date != start_date + desired_installments.months
      errors.add(:end_date, "does not match number of remaining months")
    elsif periodicity == 'bimonthly' && end_date != start_date + (desired_installments * 15.days)
      errors.add(:end_date, "does not match number of remaining quincenas")
    end
  end

  def installments_match_participants
    unless desired_installments == desired_participants
      errors.add(:desired_installments, 'do not match the number of participants')
    end
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
    periodicity_multiplier = case periodicity
                             when 'monthly' then 1.month
                             when 'bimonthly' then 15.days
                             when 'daily' then 1.day
                             else
                               raise ArgumentError, "Unsupported periodicity: #{periodicity}"
                             end

    participants.order(:position).each.with_index(1) do |participant, index|
      participant.update(
        withdrawal_date: start_date + (index * periodicity_multiplier),
        payments_expected: desired_installments - 1
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

    withdrawal_dates = participants.pluck(:withdrawal_date).compact.select { |date| date >= Time.zone.now }
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
    participants.where('withdrawal_date >= ?', Time.zone.now).order(:withdrawal_date).first
  end

  def participants_except_next_paid
    return nil unless started?

    participants.where.not(id: next_paid_participant.id)
  end

  def unpaid_turn_participants
    return unless next_paid_participant

    participants.where.not(id: next_paid_participant.id).reject(&:paid_next_participant?)
  end

  def period_ratio
    "#{next_paid_participant.payments_received}/#{next_paid_participant.payments_expected}"
  end

  def period_progression
    return 0 unless started?

    received = next_paid_participant.payments_received
    expected = next_paid_participant.payments_expected.to_f
    (received / expected * 100).round(0)
  end

  def global_progression
    return 0 unless started?

    received = participants.where(payments_received: desired_installments - 1).count
    expected = participants.count.to_f
    (received / expected * 100).round(0)
  end
end
