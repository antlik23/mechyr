# frozen_string_literal: true

json.access_token @service.success.access_token
json.refresh_token @service.success.refresh_token
json.expires_in @service.success.expires_in

if @service.success.resource_owner
  json.user do
    json.id @service.success.resource_owner.id
    json.email @service.success.resource_owner.email
    if @service.success.resource_owner.roles.pluck(:name) == ['patient']
      json.gender @service.success.resource_owner.patient.biological_gender
      json.patient_public_id @service.success.resource_owner.patient.patient_public_id
    else
      json.gender nil
      json.patient_public_id nil
    end
    json.roles @service.success.resource_owner.roles.pluck(:name) if @service.success.resource_owner.roles
  end
end
