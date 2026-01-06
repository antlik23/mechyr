# frozen_string_literal: true

# == Schema Information
#
# Table name: voiding_diary
#
#  id                                  :bigint           not null, primary key
#  recorded_at                         :time             not null
#  slept_before_and_after              :boolean          not null
#  urine_leakage                       :boolean          not null
#  urine_leakage_type                  :integer          not null
#  urge_strength                       :integer          not null
#  urine_volume                        :enum             not null
#  beverage_type                       :integer          not null
#  fluid_intake                        :integer          not null

FactoryBot.define do
  factory :voiding_record do
    recorded_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    slept_before_and_after { Faker::Boolean.boolean }
    urine_leakage { Faker::Boolean.boolean }
    urine_leakage_type { VoidingRecord.urine_leakage_types.keys.sample }
    urge_strength { Faker::Number.between(from: 0, to: 3) }
    urine_volume { Faker::Number.between(from: 1, to: 50) }
    beverage_type { VoidingRecord.beverage_types.keys.sample }
    fluid_intake { Faker::Number.between(from: 1, to: 50) }
    voiding_diary { association :voiding_diary }
  end
end
