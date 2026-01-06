# frozen_string_literal: true

json.user do
  json.id @user.id
  json.invitation_token @user.raw_invitation_token unless Rails.env.production?
end
