# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.appointment_seconds @forms do |appointment_second|
  json.id appointment_second.id
  json.attended_appointment appointment_second.attended_appointment
  json.appointment_date appointment_second.appointment_date
  json.visual_analog_scale appointment_second.visual_analog_scale
  json.continuing_treatment appointment_second.continuing_treatment
  json.discontinuation_reason appointment_second.discontinuation_reason
  json.alternative_reason appointment_second.alternative_reason
  json.current_treatment appointment_second.current_treatment
  json.prescribed_medication appointment_second.prescribed_medication
  json.dosage appointment_second.dosage
  json.dosage_unit appointment_second.dosage_unit
  json.alternative_dosage_unit appointment_second.alternative_dosage_unit
  json.doctor_id appointment_second.doctor_id
  json.patient_id appointment_second.patient_id
  json.notes appointment_second.notes
  json.multiple_medications appointment_second.multiple_medications
  json.multiple_medications_dosage appointment_second.multiple_medications_dosage
end
