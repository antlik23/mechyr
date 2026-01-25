# frozen_string_literal: true

FactoryBot.define do
  factory :patient do
    full_name { Faker::Name.first_name }
    gender { Patient.genders.keys.sample }
    user { association :user }
  end
end
