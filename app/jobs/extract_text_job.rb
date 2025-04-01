class ExtractTextJob < ApplicationJob
  queue_as :default

  require "rtesseract"

  def perform(payment_proof)
    image_path = ActiveStorage::Blob.service.path_for(payment_proof.image.key)
    extracted_text = RTesseract.new(image_path).to_s
    parsed_data = ::PaymentProofParser.parse(extracted_text)
    payment_proof.update!(parsed_data)
  end
end
