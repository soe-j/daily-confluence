json.extract! user, :id, :token, :created_at, :updated_at
json.url user_url(user, format: :json)
