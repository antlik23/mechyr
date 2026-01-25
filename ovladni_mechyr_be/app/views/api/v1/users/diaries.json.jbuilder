# frozen_string_literal: true

json.voiding_diaries @voiding_diaries.each do |diary|
  json.id diary.id
  json.diary_start_date diary.diary_start_date
end
