# frozen_string_literal: true

json.ipss_form do
  json.id @form.id
  json.incomplete_emptying @form.incomplete_emptying
  json.frequency @form.frequency
  json.intermittent_urination @form.intermittent_urination
  json.urgency @form.urgency
  json.weak_stream @form.weak_stream
  json.straining @form.straining
  json.nocturnal_urination @form.nocturnal_urination
  json.total_score @form.total_score
  json.quality_of_life @form.quality_of_life
  json.life_quality_index @form.quality_of_life
  json.completed @form.completed
  json.completion_timestamp @form.completion_timestamp
  json.patient_id @form.patient.id
  json.patient_public_id @form.patient.patient_public_id
  json.allowed_to_create_anamnestic_form @form.patient.allowed_to_create_anamnestic_form
end
