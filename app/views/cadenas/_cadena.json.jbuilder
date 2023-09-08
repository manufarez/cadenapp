json.extract!(
  cadena,
  :id,
  :name,
  :desired_participants,
  :desired_installments,
  :installment_value,
  :start_date,
  :end_date,
  :periodicity,
  :status,
  :balance,
  :created_at,
  :updated_at
)
json.url cadena_url(cadena, format: :json)
