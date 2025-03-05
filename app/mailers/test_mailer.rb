class TestMailer < ApplicationMailer
  default from: 'contacto@cadenapp.com'

  def hello
    mail(to: 'manufarez@gmail.com', subject: "Welcome Mailgun user!").tap do |message|
      message.mailgun_options = {
        "tag" => ["abtest-option-a", "beta-user"],
        "tracking-opens" => true,
        "tracking-clicks" => "htmlonly"
      }
    end
  end
end
