# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.patients @patients do |patient|
  json.id patient.id
  json.patient_id patient.id
  json.patient_public_id patient.patient_public_id
  json.email patient.user.email
end
