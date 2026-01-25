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
    diary_start_date { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    diary_duration_days { Faker::Number.between(from: 1, to: 2) }
    bedtime_day_one { Faker::Date.between(from: DateTime.now - 1, to: DateTime.now) }
    wake_up_time_day_one { Faker::Date.between(from: DateTime.now - 1, to: DateTime.now) }
    bedtime_day_two { Faker::Date.between(from: DateTime.now - 1, to: DateTime.now) }
    wake_up_time_day_two { Faker::Date.between(from: DateTime.now - 1, to: DateTime.now) }
    patient { association :patient }
  end
end
