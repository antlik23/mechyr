# frozen_string_literal: true

# Entry Form Example (Schema Information)
#
# Table name: appointment_seconds
#
#  id                                 :bigint           not null, primary key
#  attended_appointment               :boolean
#  appointment_date                   :datetime
#  continuing_treatment               :boolean
#  discontinuation_reason             :integer
#  alternative_reason                 :string
#  current_treatment                  :integer
#  prescribed_medication              :integer
#  dosage                             :float
#  dosage_unit                        :integer
#  alternative_dosage_unit            :string
#  doctor_id                          :bigint           not null, foreign key
#  patient_id                         :bigint           not null, foreign key
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null

FactoryBot.define do
  factory :appointment_second do
    attended_appointment { Faker::Boolean.boolean }
    visual_analog_scale { Faker::Number.between(from: 0, to: 10) }
    appointment_date { Time.current }
    continuing_treatment { AppointmentSecond.continuing_treatments.keys.sample }
    discontinuation_reason { AppointmentSecond.discontinuation_reasons.keys.sample }
    alternative_reason { Faker::Lorem.sentence(word_count: 3) }
    current_treatment { AppointmentSecond.current_treatments.keys.sample }
    prescribed_medication { AppointmentSecond.prescribed_medications.keys.sample }
    dosage { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    dosage_unit { AppointmentSecond.dosage_units.keys.sample }
    alternative_dosage_unit { Faker::Lorem.word }
    doctor { association :doctor }
    patient { association :patient }
    notes { Faker::Lorem.paragraph }
    multiple_medications_dosage { Faker::Lorem.sentence }
    multiple_medications { Faker::Lorem.sentence }
  end
end
