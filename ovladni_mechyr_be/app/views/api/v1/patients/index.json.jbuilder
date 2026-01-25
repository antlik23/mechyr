# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.patients @patients do |patient|
  json.id patient.user.id
  json.patient_id patient.id
  json.patient_public_id patient.patient_public_id
  json.email patient.user.email
  json.next_appointment patient.next_appointment
  json.appointment_initial patient.appointment_initial.present?
  json.appointment_initial_id patient.appointment_initial&.id
  json.appointment_first patient.appointment_first.present?
  json.appointment_first_id patient.appointment_first&.id
  json.appointment_second patient.appointment_second.present?
  json.appointment_second_id patient.appointment_second&.id
end
