class Participant < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :cadena, optional: true
  has_many :received_payments, class_name: 'Payment', dependent: :destroy
  validate :cadena_start_must_be_future, on: :create
  validate :cadena_must_have_capacity, on: :create

  delegate :name, to: :user
  delegate :first_name, to: :user
  delegate :last_name, to: :user
  delegate :avatar, to: :user
  delegate :email, to: :user

  after_create :send_participant_email, unless: -> { Rails.application.config.seeding }

  def self.find_by_name(name)
    first_name, last_name = name.split(' ', 2)
    joins(:user).find_by(users: { first_name: first_name, last_name: last_name })
  end

  def paid_next_participant?
    return false unless cadena.next_paid_participant

    Payment.where(user: user, participant: cadena.next_paid_participant).present?
  end

  def paid_previous_participant?
    return false unless cadena.previous_paid_participant

    Payment.where(user: user, participant: cadena.previous_paid_participant).present?
  end

  def paid_by_everyone
    payments_expected == payments_received && payments_received.positive?
  end

  private

  def send_participant_email
    return if self == cadena.admin

    CadenaMailer.new_participant_email(cadena, self).deliver_later
    CadenaMailer.welcome_email(cadena, self).deliver_later
  end

  def cadena_start_must_be_future
    return if cadena.start_date_is_future

    errors.add(:cadena, 'start day is today or has already passed')
  end

  def cadena_must_have_capacity
    return if cadena.missing_participants.positive?

    errors.add(:cadena, 'is full')
  end
end
