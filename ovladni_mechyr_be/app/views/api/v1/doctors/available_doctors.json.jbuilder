# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.doctors @doctors do |doctor|
  json.id doctor.user_id
  json.full_name doctor.full_name
  json.workplace doctor.workplace
  json.contact_email doctor.contact_email
  json.contact_phone doctor.contact_phone
  json.postal_code doctor.postal_code
  json.city doctor.city
  json.street_and_number doctor.street_and_number
  json.latitude doctor.latitude
  json.longitude doctor.longitude
  json.web doctor.web
end
