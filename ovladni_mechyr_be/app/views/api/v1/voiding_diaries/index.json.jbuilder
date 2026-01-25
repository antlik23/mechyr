# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.voiding_diaries @forms do |voiding_diary|
  json.id voiding_diary.id
  json.diary_start_date voiding_diary.diary_start_date
  json.diary_duration_days voiding_diary.diary_duration_days
  json.bedtime_day_one voiding_diary.bedtime_day_one&.strftime('%H:%M')
  json.wake_up_time_day_one voiding_diary.wake_up_time_day_one&.strftime('%H:%M')
  json.bedtime_day_two voiding_diary.bedtime_day_two&.strftime('%H:%M')
  json.wake_up_time_day_two voiding_diary.wake_up_time_day_two&.strftime('%H:%M')
  json.patient_id voiding_diary.patient_id
end
