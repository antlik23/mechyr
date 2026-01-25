# frozen_string_literal: true

json.user do
  json.id @user_by_token.id
  json.email @user_by_token.email
end
