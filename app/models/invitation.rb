class Invitation < ApplicationRecord
  belongs_to :cadena
  belongs_to :sender, class_name: "User"
  before_create :generate_token
  after_create :send_invitation_email, unless: -> { Rails.application.config.seeding }
  # validates :phone, presence: true
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validate :cadena_must_be_pending
  validate :cadena_start_must_be_future, on: :create

  def older_than_1day
    Time.zone.now > created_at + 1.day
  end

  def name
    "#{first_name} #{last_name}"
  end

  private

  def send_invitation_email
    InvitationMailer.invitation_email(self).deliver_later
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64(32)
  end

  def cadena_must_be_pending
    return if cadena.pending?

    errors.add(:cadena, "is at maximum capacity")
  end

  def cadena_start_must_be_future
    return if cadena.start_date_is_future

    errors.add(:cadena, "start day is today or has already passed")
  end
end
