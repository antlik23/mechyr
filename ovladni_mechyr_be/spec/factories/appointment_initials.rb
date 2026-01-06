# frozen_string_literal: true

# Entry Form Example (Schema Information)
#
# Table name: appointment_initials
#
#  id                                   :bigint           not null, primary key
#  assessment_date                      :datetime
#  diagnosis                            :integer
#  alternative_diagnosis                :string
#  oab_treatment_criteria_met           :boolean
#  initiate_pharmacological_treatment   :boolean
#  prescribed_medication                :integer
#  dosage                               :float
#  dosage_unit                          :integer
#  alternative_dosage_unit              :string
#  reason_treatment_not_started         :integer
#  alternative_treatment_details        :string
#  doctor_id                            :integer (foreign key)
#  patient_id                           :integer (foreign key)

FactoryBot.define do
  factory :appointment_initial do
    assessment_date { Time.current }
    diagnosis { AppointmentInitial.diagnoses.keys.sample }
    alternative_diagnosis { Faker::Lorem.sentence(word_count: 3) }
    oab_treatment_criteria_met { Faker::Boolean.boolean }
    initiate_pharmacological_treatment { Faker::Boolean.boolean }
    prescribed_medication { AppointmentInitial.prescribed_medications.keys.sample }
    dosage { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    dosage_unit { AppointmentInitial.dosage_units.keys.sample }
    alternative_dosage_unit { Faker::Lorem.word }
    reason_treatment_not_started { AppointmentInitial.reason_treatment_not_starteds.keys.sample }
    alternative_treatment_details { Faker::Lorem.paragraph }
    doctor { association :doctor }
    patient { association :patient }
  end
end
