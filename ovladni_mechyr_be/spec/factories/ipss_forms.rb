# frozen_string_literal: true

# == Schema Information
#
# Table name: ipss_forms
#
#  id                          :bigint           not null, primary key
#  incomplete_emptying        :integer
#  frequency                  :integer
#  intermittent_urination      :integer
#  urgency                     :integer
#  weak_stream                 :integer
#  straining                   :integer
#  nocturnal_urination        :integer
#  total_score                :integer
#  quality_of_life            :integer
#  completed                  :boolean          default(FALSE)
#  completion_timestamp       :datetime
#  patient_id                 :bigint
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

FactoryBot.define do
  factory :ipss_form do
    incomplete_emptying { Faker::Number.between(from: 0, to: 5) }
    frequency { Faker::Number.between(from: 0, to: 5) }
    intermittent_urination { Faker::Number.between(from: 0, to: 5) }
    urgency { Faker::Number.between(from: 0, to: 5) }
    weak_stream { Faker::Number.between(from: 0, to: 5) }
    straining { Faker::Number.between(from: 0, to: 5) }
    nocturnal_urination { Faker::Number.between(from: 0, to: 5) }
    total_score { Faker::Number.between(from: 5, to: 50) }
    quality_of_life { Faker::Number.between(from: 0, to: 6) }
    completed { Faker::Boolean.boolean }
    completion_timestamp { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) if completed }
    patient { association :patient }
  end
end
