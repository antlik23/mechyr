# frozen_string_literal: true

json.user do
  json.id @user.id
  json.email @user.email
  json.reset_password_token @token unless Rails.env.production?
end
