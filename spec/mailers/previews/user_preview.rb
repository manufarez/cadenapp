class UserPreview < ActionMailer::Preview
  def partial_registration_confirmation_email_preview
    user = User.last
    UserMailer.partial_registration_confirmation_email(user)
  end
end
