class TestMailer < ApplicationMailer
  default from: 'contacto@cadenapp.com'

  def hello
    mail(
      subject: 'Hello from Mailgun', # rubocop:disable Rails/I18nLocaleTexts
      to: 'contacto@cadenapp.com',
      from: 'contacto@cadenapp.com',
      html_body: '<strong>Hello</strong> dear Mailgun user.',
      track_opens: 'true',
      message_stream: 'outbound'
    )
  end
end
