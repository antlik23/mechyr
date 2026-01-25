# frozen_string_literal: true

json.appointment_initial do
  json.id @form.id
  json.assessment_date @form.assessment_date
  json.diagnosis @form.diagnosis
  json.alternative_diagnosis @form.alternative_diagnosis
  json.oab_treatment_criteria_met @form.oab_treatment_criteria_met
  json.initiate_pharmacological_treatment @form.initiate_pharmacological_treatment
  json.prescribed_medication @form.prescribed_medication
  json.dosage @form.dosage
  json.dosage_unit @form.dosage_unit
  json.alternative_dosage_unit @form.alternative_dosage_unit
  json.reason_treatment_not_started @form.reason_treatment_not_started
  json.alternative_treatment_details @form.alternative_treatment_details
  json.doctor_user_id @form.doctor.user_id
  json.patient_id @form.patient.id
  json.patient_public_id @form.patient.patient_public_id
end
