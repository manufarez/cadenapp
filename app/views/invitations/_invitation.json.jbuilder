json.extract! invitation, :id, :phone, :first_name, :last_name, :accepted, :cadena_id, :created_at, :updated_at
json.url invitation_url(invitation, format: :json)
