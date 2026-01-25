# frozen_string_literal: true

if @form.present?
  json.voiding_diary do
    json.id @form.id
    json.diary_start_date @form.diary_start_date
    json.diary_duration_days @form.diary_duration_days
    json.bedtime_day_one @form.bedtime_day_one&.strftime('%H:%M')
    json.wake_up_time_day_one @form.wake_up_time_day_one&.strftime('%H:%M')
    json.bedtime_day_two @form.bedtime_day_two&.strftime('%H:%M')
    json.wake_up_time_day_two @form.wake_up_time_day_two&.strftime('%H:%M')
    json.completed @form.completed
    json.patient_id @form.patient.patient_public_id
    json.fluid_intake_volume @form.fluid_intake_volume
    json.voided_volume @form.voided_volume
    json.nocturnal_voided_volume @form.nocturnal_voided_volume
    json.polyuria @form.polyuria
    json.nocturnal_polyuria_index @form.nocturnal_polyuria_index
    json.frequency @form.urination_frequency
    json.nocturnal_voids @form.nocturnal_voids
    json.urgencies @form.urgencies
    json.urgent_incontinence @form.urgent_incontinence
    json.incontinence_episodes @form.incontinence_episodes
    json.max_voided_volume @form.max_voided_volume
    json.median_voided_volume @form.median_voided_volume
    json.average_voided_volume @form.average_voided_volume
  end
else
  json.voiding_diary nil
end
json.allowed_to_create_voiding_diary @allowed_to_create_voiding_diary
