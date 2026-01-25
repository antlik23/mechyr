# frozen_string_literal: true

json.appointment_second do
  json.id @form.id
end

json.appointment_first do
  json.id @form.patient.appointment_first.id
  json.appointment_date @form.patient.appointment_first.appointment_date
end
