class PaymentProofParser
  def self.parse(text)
    {
      bank_name: extract_bank_name(text),
      amount: extract_amount(text),
      number: extract_cus_id(text),
      account_number: extract_account_number(text),
      account_type: extract_account_type(text),
      transfer_timestamp: extract_transfer_timestamp(text)
    }
  end

  def self.extract_bank_name(text)
    # Match "Scotiabank COLPATRIA" and clean extra characters
    text[/Scotiabank/i]&.gsub(/[^a-zA-Z\s]/, "")&.+ " COLPATRIA"
  end

  def self.extract_amount(text)
    # Match the amount, e.g., "$128,290", and remove formatting
    text[/Pago exitoso por\s+\$(\d[\d,]*)/, 1]&.delete(",")&.to_i
  end

  def self.extract_cus_id(text)
    # Match "Referencia de pago (CUS ID): 1067044897"
    text[/CUS ID\):\s*(\d+)/, 1]
  end

  def self.extract_account_number(text)
    # Match the account number "2451" after "Cuenta de ahorros"
    text[/Cuenta de ahorros.*(\d{4})/, 1]
  end

  def self.extract_account_type(text)
    # Match "Cuenta de ahorros"
    text[/Cuenta de ahorros/]
  end

  def self.extract_transfer_timestamp(text)
    # Match the timestamp and format for Rails
    raw_timestamp = text[/\w{3}\s\d{1,2},\s\d{4}\s-\s\d{2}:\d{2}\s(?:AM|PM)/]
    return unless raw_timestamp

    # Parse into Rails-compatible datetime
    DateTime.strptime(raw_timestamp, "%b %d, %Y - %I:%M %p").to_s
  end
end
