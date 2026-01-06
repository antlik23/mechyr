# frozen_string_literal: true

json.appointment_second do
  json.id @form.id
  json.attended_appointment @form.attended_appointment
  json.appointment_date @form.appointment_date
  json.visual_analog_scale @form.visual_analog_scale
  json.continuing_treatment @form.continuing_treatment
  json.discontinuation_reason @form.discontinuation_reason
  json.alternative_reason @form.alternative_reason
  json.current_treatment @form.current_treatment
  json.prescribed_medication @form.prescribed_medication
  json.dosage @form.dosage
  json.dosage_unit @form.dosage_unit
  json.alternative_dosage_unit @form.alternative_dosage_unit
  json.doctor_user_id @form.doctor.user_id
  json.patient_id @form.patient.id
  json.patient_public_id @form.patient.patient_public_id
  json.notes @form.notes
  json.multiple_medications @form.multiple_medications
  json.multiple_medications_dosage @form.multiple_medications_dosage
end

json.appointment_first do
  json.id @form.patient.appointment_first.id
  json.appointment_date @form.patient.appointment_first.appointment_date
end
