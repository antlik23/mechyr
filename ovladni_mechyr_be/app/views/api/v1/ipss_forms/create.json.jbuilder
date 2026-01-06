# frozen_string_literal: true

json.ipss_form do
  json.id @form.id
  json.total_score @form.total_score
  json.life_quality_index @form.quality_of_life
  json.allowed_to_create_anamnestic_form @form.patient.allowed_to_create_anamnestic_form
end
