# Preview all emails at http://localhost:3000/rails/mailers/payment
class PaymentPreview < ActionMailer::Preview
  def new_payment_email_preview
    payment = Payment.last
    PaymentMailer.new_payment_email(payment)
  end
end
