# frozen_string_literal: true

json.appointment_first do
  json.id @form.id
end

json.appointment_initial do
  json.id @form.patient.appointment_initial.id
  json.assessment_date @form.patient.appointment_initial.assessment_date
end
