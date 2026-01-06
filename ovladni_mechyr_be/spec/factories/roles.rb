# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id            :bigint           not null, primary key
#  name          :string
#  resource_type :string
#  resource_id   :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :role do
    name { Role::ADMIN }
    factory :patient_role do
      name { Role::PATIENT }
    end
    factory :doctor_role do
      name { Role::DOCTOR }
    end
  end
end
