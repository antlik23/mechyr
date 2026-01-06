# frozen_string_literal: true

json.oab_form do
  json.id @form.id
  json.total_score @form.total_score
  json.allowed_to_create_iciq_form @form.patient.allowed_to_create_iciq_form
end
