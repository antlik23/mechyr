# frozen_string_literal: true

# == Schema Information
#
# Table name: oab_forms
#
#  id                          :bigint           not null, primary key
#  daytime_urination_frequency :integer
#  unpleasant_urination_urge  :integer
#  sudden_urination_urge      :integer
#  occasional_leak            :integer
#  nighttime_urination        :integer
#  waking_up_to_urinate       :integer
#  uncontrollable_urge        :integer
#  leak_due_to_intense_urge   :integer
#  total_score                :integer
#  completed                  :boolean          default(FALSE)
#  completion_timestamp       :datetime
#  patient_id                 :bigint
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
FactoryBot.define do
  factory :oab_form do
    daytime_urination_frequency { Faker::Number.between(from: 0, to: 5) }
    unpleasant_urination_urge { Faker::Number.between(from: 0, to: 5) }
    sudden_urination_urge { Faker::Number.between(from: 0, to: 5) }
    occasional_leak { Faker::Number.between(from: 0, to: 5) }
    nighttime_urination { Faker::Number.between(from: 0, to: 5) }
    waking_up_to_urinate { Faker::Number.between(from: 0, to: 5) }
    uncontrollable_urge { Faker::Number.between(from: 0, to: 5) }
    leak_due_to_intense_urge { Faker::Number.between(from: 0, to: 5) }
    total_score { Faker::Number.between(from: 5, to: 50) }
    completed { Faker::Boolean.boolean }
    completion_timestamp { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) if completed }
    patient { association :patient }
  end
end
