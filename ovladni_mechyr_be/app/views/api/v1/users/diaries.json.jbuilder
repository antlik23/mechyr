# frozen_string_literal: true

json.voiding_diaries @voiding_diaries.each do |diary|
  json.id diary.id
  json.diary_start_date diary.diary_start_date
  json.completed diary.completed
  json.voiding_records_count diary.voiding_records.count
end
