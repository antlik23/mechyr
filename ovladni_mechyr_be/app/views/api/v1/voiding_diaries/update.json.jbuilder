# frozen_string_literal: true

json.voiding_diary do
  json.id @form.id
  json.completed @form.completed

  # Include doctor selection information if diary was just completed
  # Only show dialog if patient doesn't have a doctor yet
  if @form.completed
    patient = @form.patient
    if patient.doctor_id.nil?
      json.should_select_doctor true
      json.can_select_doctor patient.can_be_assigned
    end
  end
end
