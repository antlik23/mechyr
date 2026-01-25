# frozen_string_literal: true

json.access_token @token.access_token
json.refresh_token @token.refresh_token
json.expires_in @token.expires_in

if @token.resource_owner
  json.user do
    json.id @token.resource_owner.id
    json.email @token.resource_owner.email
    json.gender nil
    json.roles @token.resource_owner.roles.pluck(:name) || []
  end
else
  json.user do
    json.id nil
    json.email nil
    json.roles []
  end
end
