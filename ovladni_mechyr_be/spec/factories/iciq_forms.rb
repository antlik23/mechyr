# frozen_string_literal: true

# == Schema Information
#
# Table name: iciq_forms
#
#  id                                 :bigint           not null, primary key
#  leakage_frequency                 :integer
#  leakage_assessment                :integer
#  leakage_severity                  :integer
#  never_leaks                       :boolean
#  leaks_before_reaching_toilet      :boolean
#  leaks_when_coughing_or_sneezing    :boolean
#  leaks_during_sleep                :boolean
#  leaks_during_physical_activity    :boolean
#  leaks_after_urinating_and_dressing:boolean
#  leaks_for_unknown_reasons         :boolean
#  constant_leakage                  :boolean
#  total_score                       :integer
#  completed                         :boolean          default(FALSE)
#  completion_timestamp              :datetime
#  patient_id                 :bigint
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

FactoryBot.define do
  factory :iciq_form do
    leakage_frequency { Faker::Number.between(from: 0, to: 5) }
    leakage_assessment { Faker::Number.between(from: 0, to: 3) }
    leakage_severity { Faker::Number.between(from: 1, to: 10) }
    never_leaks { Faker::Boolean.boolean }
    leaks_before_reaching_toilet { Faker::Boolean.boolean }
    leaks_when_coughing_or_sneezing { Faker::Boolean.boolean }
    leaks_during_sleep { Faker::Boolean.boolean }
    leaks_during_physical_activity { Faker::Boolean.boolean }
    leaks_after_urinating_and_dressing { Faker::Boolean.boolean }
    leaks_for_unknown_reasons { Faker::Boolean.boolean }
    constant_leakage { Faker::Boolean.boolean }
    total_score { Faker::Number.between(from: 1, to: 15) }
    completed { Faker::Boolean.boolean }
    completion_timestamp { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) if completed }
    patient { association :patient }
  end
end
