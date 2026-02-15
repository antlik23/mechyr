# frozen_string_literal: true

# == Schema Information
#
# Table name: voiding_diary
#
#  id                                  :bigint           not null, primary key
#  diary_start_date                    :datetime         not null
#  diary_duration_days                 :integer          not null
#  usual_bedtime                       :time             not null
#  usual_wake_up_time                  :time             not null

FactoryBot.define do
  factory :voiding_diary do
    diary_start_date { Date.today }
    diary_duration_days { Faker::Number.between(from: 1, to: 2) }
    bedtime_day_one { Time.current }
    wake_up_time_day_one { Time.current + 8.hours }
    bedtime_day_two { Time.current + 1.day }
    wake_up_time_day_two { Time.current + 1.day + 8.hours }
    patient { association :patient }
  end
end
