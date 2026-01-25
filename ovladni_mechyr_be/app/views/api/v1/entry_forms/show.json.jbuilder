# frozen_string_literal: true

json.entry_form do
  json.id @form.id
  json.urination_frequency_issue @form.urination_frequency_issue
  json.urinations_per_day @form.urinations_per_day
  json.fluid_intake_volume @form.fluid_intake_volume
  json.patient_id @form.patient.id
  json.patient_public_id @form.patient.patient_public_id
end
