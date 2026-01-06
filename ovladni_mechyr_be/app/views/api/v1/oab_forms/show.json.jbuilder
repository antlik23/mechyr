# frozen_string_literal: true

json.oab_form do
  json.id @form.id
  json.daytime_urination_frequency @form.daytime_urination_frequency
  json.unpleasant_urination_urge @form.unpleasant_urination_urge
  json.sudden_urination_urge @form.sudden_urination_urge
  json.occasional_leak @form.occasional_leak
  json.nighttime_urination @form.nighttime_urination
  json.waking_up_to_urinate @form.waking_up_to_urinate
  json.uncontrollable_urge @form.uncontrollable_urge
  json.leak_due_to_intense_urge @form.leak_due_to_intense_urge
  json.total_score @form.total_score
  json.completed @form.completed
  json.completion_timestamp @form.completion_timestamp
  json.patient_id @form.patient.id
  json.patient_public_id @form.patient.patient_public_id
  json.allowed_to_create_iciq_form @form.patient.allowed_to_create_iciq_form
  json.gender @form.patient.biological_gender
end
