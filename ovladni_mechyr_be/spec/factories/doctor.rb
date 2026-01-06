# frozen_string_literal: true

FactoryBot.define do
  factory :doctor do
    full_name { Faker::Name.first_name }
    user { association :user }
    workplace { Faker::Company.name }
    contact_email { Faker::Internet.email }
    contact_phone { Faker::PhoneNumber.phone_number }
    city { Faker::Address.city }
    postal_code { Faker::Address.zip_code }
    street_and_number { Faker::Address.street_address }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    full_capacity { false }
    web { Faker::Internet.url }
  end
end
