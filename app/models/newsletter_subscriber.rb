class NewsletterSubscriber < ApplicationRecord
  belongs_to :user, optional: true

  scope :active, -> { where(unsubscribed_at: nil) }

  validates :email, presence: true, uniqueness: true

  def self.link_to_user(user)
    if existing = find_by(email: user.email)
      existing.update!(user: user)
    else
      create!(email: user.email, user: user)
    end
  end

  def unsubscribed?
    unsubscribed_at.present?
  end
end
