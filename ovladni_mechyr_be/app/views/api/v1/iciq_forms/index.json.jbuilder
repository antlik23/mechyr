# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.iciq_forms @forms do |iciq_form|
  json.id iciq_form.id
  json.leakage_frequency iciq_form.leakage_frequency
  json.leakage_assessment iciq_form.leakage_assessment
  json.leakage_severity iciq_form.leakage_severity
  json.never_leaks iciq_form.never_leaks
  json.leaks_before_reaching_toilet iciq_form.leaks_before_reaching_toilet
  json.leaks_when_coughing_or_sneezing iciq_form.leaks_when_coughing_or_sneezing
  json.leaks_during_sleep iciq_form.leaks_during_sleep
  json.leaks_during_physical_activity iciq_form.leaks_during_physical_activity
  json.leaks_after_urinating_and_dressing iciq_form.leaks_after_urinating_and_dressing
  json.leaks_for_unknown_reasons iciq_form.leaks_for_unknown_reasons
  json.constant_leakage iciq_form.constant_leakage
  json.total_score iciq_form.total_score
  json.completed iciq_form.completed
  json.completion_timestamp iciq_form.completion_timestamp
  json.allowed_to_create_ipss_form iciq_form.patient.allowed_to_create_ipss_form
  json.allowed_to_create_anamnestic_form iciq_form.patient.allowed_to_create_anamnestic_form
end
