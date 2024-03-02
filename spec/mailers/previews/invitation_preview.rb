# Preview all emails at http://localhost:3000/rails/mailers/payment
class InvitationPreview < ActionMailer::Preview
  def invitation_email_preview
    invitation = Invitation.last
    InvitationMailer.invitation_email(invitation)
  end
end
