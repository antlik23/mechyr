# frozen_string_literal: true

json.iciq_form do
  json.id @form.id
  json.total_score @form.total_score
  json.allowed_to_create_ipss_form @form.patient.allowed_to_create_ipss_form
  json.allowed_to_create_anamnestic_form @form.patient.allowed_to_create_anamnestic_form
end
