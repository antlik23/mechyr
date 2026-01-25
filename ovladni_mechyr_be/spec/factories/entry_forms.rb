# frozen_string_literal: true

# == Schema Information
#
# Table name: entry_forms
#
#  id                                  :bigint           not null, primary key
#  urination_frequency_issue           :boolean
#  urinations_per_day                  :integer          not null
#  fluid_intake_volume                 :float            not null

FactoryBot.define do
  factory :entry_form do
    urination_frequency_issue { Faker::Boolean.boolean }
    urinations_per_day { Faker::Number.between(from: 0, to: 100) }
    fluid_intake_volume { Faker::Number.between(from: 0, to: 12) }
  end
end
