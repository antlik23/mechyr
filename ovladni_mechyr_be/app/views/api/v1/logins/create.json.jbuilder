# frozen_string_literal: true

json.access_token @token.access_token
json.refresh_token @token.refresh_token
json.expires_in @token.expires_in

if @token.resource_owner
  json.user do
    json.id @token.resource_owner.id
    json.email @token.resource_owner.email
    if @token.resource_owner.roles.pluck(:name) == ['patient']
      json.gender @token.resource_owner.patient.biological_gender
      json.patient_public_id @token.resource_owner.patient.patient_public_id
    else
      json.gender nil
      json.patient_public_id nil
    end
    json.roles @token.resource_owner.roles.pluck(:name) if @token.resource_owner.roles
  end
else
  json.user do
    json.id nil
    json.email nil
    json.first_name nil
    json.last_name nil
    json.role nil
    json.roles []
  end
end
