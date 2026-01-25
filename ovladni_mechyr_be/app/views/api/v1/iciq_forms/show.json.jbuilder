# frozen_string_literal: true

json.iciq_form do
  json.id @form.id
  json.leakage_frequency @form.leakage_frequency
  json.leakage_assessment @form.leakage_assessment
  json.leakage_severity @form.leakage_severity
  json.never_leaks @form.never_leaks
  json.leaks_before_reaching_toilet @form.leaks_before_reaching_toilet
  json.leaks_when_coughing_or_sneezing @form.leaks_when_coughing_or_sneezing
  json.leaks_during_sleep @form.leaks_during_sleep
  json.leaks_during_physical_activity @form.leaks_during_physical_activity
  json.leaks_after_urinating_and_dressing @form.leaks_after_urinating_and_dressing
  json.leaks_for_unknown_reasons @form.leaks_for_unknown_reasons
  json.constant_leakage @form.constant_leakage
  json.total_score @form.total_score
  json.completed @form.completed
  json.completion_timestamp @form.completion_timestamp
  json.patient_id @form.patient.id
  json.patient_public_id @form.patient.patient_public_id
  json.allowed_to_create_ipss_form @form.patient.allowed_to_create_ipss_form
  json.allowed_to_create_anamnestic_form @form.patient.allowed_to_create_anamnestic_form
end
