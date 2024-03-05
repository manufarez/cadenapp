class NewsletterSubscriber < ApplicationRecord
  belongs_to :user, optional: true

  scope :active, -> { where(unsubscribed_at: nil) }

  validates :email, presence: true

  def self.link_to_user(user)
    if (existing = User.find_by(email: user.email))
      user.update!(user_id: existing.id)
    else
      create!(email: user.email)
    end
  end

  def unsubscribed?
    unsubscribed_at.present?
  end
end
