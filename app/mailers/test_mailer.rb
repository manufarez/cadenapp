class TestMailer < ApplicationMailer
  default from: 'contacto@cadenapp.com'

  def hello
    mail(
      subject: 'Hello from Postmark',
      to: 'contacto@cadenapp.com',
      from: 'contacto@cadenapp.com',
      html_body: '<strong>Hello</strong> dear Postmark user.',
      track_opens: 'true',
      message_stream: 'outbound'
    )
  end
end
