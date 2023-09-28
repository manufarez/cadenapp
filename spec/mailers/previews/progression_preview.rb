# Preview all emails at http://localhost:3000/rails/mailers/progression
class ProgressionPreview < ActionMailer::Preview
  def period_complete_email_preview
    participant = Participant.find { |p| p.withdrawal_day && p.position }
    ProgressionMailer.period_complete_email(participant)
  end
end
