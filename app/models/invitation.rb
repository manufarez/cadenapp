class Invitation < ApplicationRecord
  belongs_to :cadena
  belongs_to :sender, class_name: 'User'
  before_create :generate_token
  after_create :send_invitation_email, unless: -> { Rails.application.config.seeding }

  def older_than_1h
    Time.zone.today - 1.hour == created_at
  end

  def name
    "#{first_name} #{last_name}"
  end

  private

  def send_invitation_email
    InvitationMailer.invite_email(self).deliver_now
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64(32)
  end
end
