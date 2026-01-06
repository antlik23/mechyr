# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.appointment_firsts @forms do |appointment_first|
  json.id appointment_first.id
  json.appointment_date appointment_first.appointment_date
  json.consent_signed appointment_first.consent_signed
  json.meets_project_criteria appointment_first.meets_project_criteria
  json.clinical_assessment_completed appointment_first.clinical_assessment_completed
  json.prolapse_present appointment_first.prolapse_present
  json.stress_test_done appointment_first.stress_test_done
  json.stress_test_result appointment_first.stress_test_result
  json.uti_excluded appointment_first.uti_excluded
  json.bladder_discomfort_vas appointment_first.bladder_discomfort_vas
  json.diagnosis appointment_first.diagnosis
  json.alternative_diagnosis appointment_first.alternative_diagnosis
  json.oab_treatment_criteria_met appointment_first.oab_treatment_criteria_met
  json.prescribed_medication appointment_first.prescribed_medication
  json.dosage appointment_first.dosage
  json.dosage_unit appointment_first.dosage_unit
  json.alternative_dosage_unit appointment_first.alternative_dosage_unit
  json.reason_treatment_not_started appointment_first.reason_treatment_not_started
  json.alternative_treatment_details appointment_first.alternative_treatment_details
  json.treatment_contraindications appointment_first.treatment_contraindications
  json.follow_up_date appointment_first.follow_up_date
  json.doctor_id appointment_first.doctor_id
  json.patient_id appointment_first.patient_id
  json.notes appointment_first.notes
  json.blood_in_urine appointment_first.blood_in_urine
  json.protein_in_urine appointment_first.protein_in_urine
  json.sugar_in_urine appointment_first.sugar_in_urine
  json.post_void_residual_over_100_ml appointment_first.post_void_residual_over_100_ml
end
