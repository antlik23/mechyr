# frozen_string_literal: true

json.user do
  json.id @user.id
  json.email @user.email
  json.roles @user.roles.pluck(:name)
  if @user.roles.pluck(:name) == ['patient']
    json.full_name @user.patient.full_name
    if ['male', 'female'].include?(@user.patient.gender)
      json.gender @user.patient.gender
      json.other_gender nil
    else
      json.gender 'other'
      json.other_gender @user.patient.gender
    end
    json.doctor_id @user.patient.doctor_id
    json.patient_public_id @user.patient.patient_public_id
    json.patient_id @user.patient.id
    json.approved @user.patient.approved
    json.entry_form_id @user.patient.entry_form&.id
    json.oab_form_ids @user.patient.oab_forms&.ids
    json.ipss_form_ids @user.patient.ipss_forms&.ids
    json.iciq_form_ids @user.patient.iciq_forms&.ids
    json.anamnestic_form_ids @user.patient.anamnestic_forms&.ids
    json.appointment_initial_id @user.patient.appointment_initial&.id
    json.appointment_first_id @user.patient.appointment_first&.id
    json.appointment_second_id @user.patient.appointment_second&.id
    json.voiding_diary_ids @user.patient.voiding_diaries&.ids
    json.next_appointment @user.patient.next_appointment
    json.allowed_to_create_second_appointment @user.patient.allowed_to_second_appointment
    json.doctor_name @user.patient.doctor&.full_name
  elsif @user.roles.pluck(:name) == ['doctor']
    json.full_name @user.doctor.full_name
    json.workplace @user.doctor.workplace
    json.contact_email @user.doctor.contact_email
    json.contact_phone @user.doctor.contact_phone
    json.city @user.doctor.city
    json.working_hours @user.doctor.working_hours
    json.postal_code @user.doctor.postal_code
    json.street_and_number @user.doctor.street_and_number
    json.full_capacity @user.doctor.full_capacity
    json.latitude @user.doctor.latitude
    json.longitude @user.doctor.longitude
    json.is_contactable @user.doctor.is_contactable
    json.web @user.doctor.web
    if @current_user.patient&.can_be_assigned
      json.contact_status 'allowed'
    elsif @user.doctor == @current_user.patient&.doctor
      json.contact_status 'contacted'
    else
      json.contact_status 'forbidden'
    end
  end
end
