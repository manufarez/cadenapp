class ExtractTextJob < ApplicationJob
  queue_as :default

  require 'rtesseract'

  def perform(payment_proof)
    image_path = ActiveStorage::Blob.service.path_for(payment_proof.image.key)
    payment_proof.bank_name = RTesseract.new(image_path).to_s
    payment_proof.save!
  end
end
