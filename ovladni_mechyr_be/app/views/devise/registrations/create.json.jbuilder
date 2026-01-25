# frozen_string_literal: true

json.user do
  json.id current_user.id
  json.first_name current_user.first_name
  json.last_name current_user.last_name
  json.token current_user.generate_jwt
end
