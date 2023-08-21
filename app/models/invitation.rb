class Invitation < ApplicationRecord
  belongs_to :cadena
  belongs_to :sender, class_name: 'User'
  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64(32)
  end
end
