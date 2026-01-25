# frozen_string_literal: true

json.appointment_first do
  json.id @form.id
  json.appointment_date @form.appointment_date
  json.consent_signed @form.consent_signed
  json.meets_project_criteria @form.meets_project_criteria
  json.clinical_assessment_completed @form.clinical_assessment_completed
  json.prolapse_present @form.prolapse_present
  json.stress_test_done @form.stress_test_done
  json.stress_test_result @form.stress_test_result
  json.uti_excluded @form.uti_excluded
  json.bladder_discomfort_vas @form.bladder_discomfort_vas
  json.diagnosis @form.diagnosis
  json.alternative_diagnosis @form.alternative_diagnosis
  json.oab_treatment_criteria_met @form.oab_treatment_criteria_met
  json.prescribed_medication @form.prescribed_medication
  json.dosage @form.dosage
  json.dosage_unit @form.dosage_unit
  json.alternative_dosage_unit @form.alternative_dosage_unit
  json.reason_treatment_not_started @form.reason_treatment_not_started
  json.alternative_treatment_details @form.alternative_treatment_details
  json.treatment_contraindications @form.treatment_contraindications
  json.follow_up_date @form.follow_up_date
  json.doctor_user_id @form.doctor.user_id
  json.patient_id @form.patient.id
  json.patient_public_id @form.patient.patient_public_id
  json.notes @form.notes
  json.blood_in_urine @form.blood_in_urine
  json.protein_in_urine @form.protein_in_urine
  json.sugar_in_urine @form.sugar_in_urine
  json.post_void_residual_over_100_ml @form.post_void_residual_over_100_ml
end

json.appointment_initial do
  json.id @form.patient.appointment_initial.id
  json.assessment_date @form.patient.appointment_initial.assessment_date
end
