class Cadena < ApplicationRecord
  has_one :admin, class_name: 'Participant', dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :users, through: :participants
  has_many :payments, dependent: :destroy
  before_create :set_saving_goal
  validates :desired_participants, presence: true
  validates :desired_installments, presence: true
  validates :name, presence: true, length: { minimum: 3, maximum: 33 }
  validates :periodicity, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :saving_goal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :installment_value, presence: true
  validates :accepts_admin_terms, acceptance: { message: I18n.t('cadena.errors.t&c_must_be_accepted') }
  validate :end_date_matches_installments
  validate :installments_match_participants, on: :create
  validates :installment_value, inclusion: { in: 100_000..500_000, message: I18n.t('cadena.errors.installments_range') }
  validates :desired_participants, inclusion: { in: 3..19, message: I18n.t('cadena.errors.participants_range') }
  enum periodicity: { daily: 'daily', bimonthly: 'bimonthly', monthly: 'monthly' }, _default: 'monthly'

  state_machine :state, initial: :pending do
    after_transition on: :start, do: :assign_positions
    after_transition to: :complete, do: :remind_admin_to_send_list
    after_transition to: :participants_approval, do: :remind_admin_to_generate_order

    event :back_to_pending do
      transition [:complete, :participants_approval] => :pending
    end

    event :complete do
      transition pending: :complete
    end

    event :approve_participants do
      transition complete: :participants_approval
    end

    event :start do
      transition participants_approval: :started
    end

    event :finish do
      transition started: :finished
    end

    event :stop do
      transition started: :stopped
    end

    event :resume do
      transition [:stopped, :finished] => :started
    end

    state :pending, :complete, :participants_approval do
      validate :start_date_is_future
    end
  end

  def start_date_is_future
    return false unless start_date.present? && %w[started stopped archived].exclude?(state)

    if start_date <= Time.zone.today
      errors.add(:start_date, "(#{start_date.strftime('%d/%m/%Y')}) #{I18n.t('cadena.should_be_future')}")
    end
    errors.empty?
  end

  def end_date_matches_installments
    return if desired_installments.blank?

    if periodicity == 'daily' && end_date != start_date + desired_installments.days - 1.day
      error_message = I18n.t('cadena.errors.end_date_does_not_match_remaining_days')
      logger.error error_message
      errors.add(:end_date, error_message)
    elsif periodicity == 'monthly' && end_date != start_date + desired_installments.months - 1.day
      error_message = I18n.t('cadena.errors.end_date_does_not_match_remaining_months')
      logger.error error_message
      errors.add(:end_date, error_message)
    elsif periodicity == 'bimonthly' && end_date != start_date + (desired_installments * 15.days) - 1.day
      error_message = I18n.t('cadena.errors.end_date_does_not_match_remaining_quincenas')
      logger.error error_message
      errors.add(:end_date, error_message)
    end
  end

  def installments_match_participants
    return if desired_installments == desired_participants

    errors.add(:desired_installments, I18n.t('cadena.errors.desired_installments_do_not_match_participants'))
  end

  def participants_names
    participants.includes(:user).map(&:name)
  end

  def participant_count
    missing_participants.positive? ? "#{participants.count}/#{desired_participants}" : participants.count
  end

  def missing_participants
    desired_participants - participants.count
  end

  def set_saving_goal
    self.saving_goal = desired_installments * installment_value
  end

  def assign_positions
    participants.shuffle.each.with_index(1) do |participant, index|
      participant.update(position: index)
    end
    calculate_withdrawal_dates
  end

  def next_payment_date
    return unless started?

    withdrawal_dates = participants.pluck(:withdrawal_date).compact.select { |date| date >= Time.zone.now.to_date }
    withdrawal_dates.min || nil
  end

  def next_payment_cycle_start
    return unless started? && !next_payment_date.nil?

    next_payment_date + 1.day
  end

  def last_payment_date
    return unless started?

    withdrawal_dates = participants.pluck(:withdrawal_date).compact.select { |date| date < Time.zone.now.to_date }
    withdrawal_dates.min || nil
  end

  def days_to_payment
    return unless started? && next_payment_date

    (next_payment_date - Time.zone.now.to_date).to_i
  end

  def next_paid_participant
    participants.where('withdrawal_date >= ?', Time.zone.now.to_date).order(:withdrawal_date).first || participants.order(position: :desc).first
  end

  def previous_paid_participant
    participants.where('withdrawal_date < ?', Time.zone.now.to_date).order(:withdrawal_date).last
  end

  def participants_except_next_paid
    return nil unless started?

    participants.where.not(id: next_paid_participant.id)
  end

  def unpaid_turn_participants
    return unless next_paid_participant

    participants.where.not(id: next_paid_participant.id).reject(&:paid_next_participant?)
  end

  def unpaid_previous_participants
    return unless previous_paid_participant

    participants.where.not(id: previous_paid_participant.id).reject(&:paid_previous_participant?)
  end

  def period_ratio
    "#{next_paid_participant.payments_received}/#{next_paid_participant.payments_expected}"
  end

  def period_progression
    return 0 unless payments.any?

    received = next_paid_participant.payments_received
    expected = next_paid_participant.payments_expected.to_f
    (received / expected * 100).round(0)
  end

  def global_progression
    return 0 unless payments.any?

    expected = participants.count.to_f
    (received_installments / expected * 100).round(0)
  end

  def received_installments
    participants.where(payments_received: desired_installments - 1).count
  end

  def remind_admin_to_send_list
    return if Rails.application.config.seeding

    CadenaMailer.remind_admin_to_send_list(self).deliver_later
  end

  def remind_admin_to_generate_order
    return if Rails.application.config.seeding

    CadenaMailer.remind_admin_to_generate_order(self).deliver_later
  end

  def admin
    return nil if admin_id.blank?

    Participant.find(admin_id)
  end

  private

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
        withdrawal_date: start_date - 1.day + (index * periodicity_multiplier),
        payments_expected: desired_installments - 1
      )
    end
  end
end
