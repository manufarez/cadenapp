class PaymentProof < ApplicationRecord
  belongs_to :cadena
  belongs_to :user
  belongs_to :participant
  belongs_to :payment

  has_one_attached :image
end
