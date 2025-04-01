class TestMailer < ApplicationMailer
  default from: "contacto@cadenapp.com"

  def hello
    mail(to: "manufarez@gmail.com", subject: "Welcome Mailgun user!").tap do |message|
      message.mailgun_options = {
        tracking_opens: true,
        tracking_clicks: "htmlonly"
      }
    end
  end
end
