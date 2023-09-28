# Preview all emails at http://localhost:3000/rails/mailers/cadena
class CadenaPreview < ActionMailer::Preview
  def new_cadena_email_preview
    cadena = Cadena.last
    admin = User.first
    CadenaMailer.new_cadena_email(cadena, admin)
  end

  def new_participant_email_preview
    cadena = Cadena.last
    participant = cadena.participants.last
    CadenaMailer.new_participant_email(cadena, participant)
  end

  def welcome_email_preview
    cadena = Cadena.last
    participant = cadena.participants.last
    CadenaMailer.welcome_email(cadena, participant)
  end

  def positions_assignal_preview
    cadena = Cadena.last
    participant = cadena.participants.last
    CadenaMailer.positions_assignal_email(cadena, participant)
  end

  def participants_approval_preview
    cadena = Cadena.last
    participant = cadena.participants.last
    CadenaMailer.participants_approval_email(cadena, participant)
  end
end
