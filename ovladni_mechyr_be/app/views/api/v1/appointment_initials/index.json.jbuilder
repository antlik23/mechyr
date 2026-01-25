# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.appointment_initials @forms do |appointment_initial|
  json.id appointment_initial.id
  json.assessment_date appointment_initial.assessment_date
  json.diagnosis appointment_initial.diagnosis
  json.alternative_diagnosis appointment_initial.alternative_diagnosis
  json.oab_treatment_criteria_met appointment_initial.oab_treatment_criteria_met
  json.initiate_pharmacological_treatment appointment_initial.initiate_pharmacological_treatment
  json.prescribed_medication appointment_initial.prescribed_medication
  json.dosage appointment_initial.dosage
  json.dosage_unit appointment_initial.dosage_unit
  json.alternative_dosage_unit appointment_initial.alternative_dosage_unit
  json.reason_treatment_not_started appointment_initial.reason_treatment_not_started
  json.alternative_treatment_details appointment_initial.alternative_treatment_details
  json.doctor_id appointment_initial.doctor_id
  json.patient_id appointment_initial.patient_id
end
