# frozen_string_literal: true

# Entry Form Example (Schema Information)
#
# Table name: appointment_firsts
#
#  id                                 :bigint           not null, primary key
#  appointment_date                   :datetime
#  consent_signed                     :boolean
#  meets_project_criteria             :boolean
#  clinical_assessment_completed      :boolean
#  prolapse_present                   :boolean
#  stress_test_done                   :boolean
#  stress_test_result                 :boolean
#  uti_excluded                       :boolean
#  bladder_discomfort_vas             :integer
#  diagnosis                          :integer
#  alternative_diagnosis              :string
#  oab_treatment_criteria_met         :boolean
#  prescribed_medication              :integer
#  dosage                             :float
#  dosage_unit                        :integer
#  alternative_dosage_unit            :string
#  reason_treatment_not_started       :integer
#  alternative_treatment_details      :string
#  treatment_contraindications        :string
#  follow_up_date                     :datetime
#  doctor_id                          :bigint           not null, foreign key
#  patient_id                         :bigint           not null, foreign key
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null

FactoryBot.define do
  factory :appointment_first do
    appointment_date { Time.current }
    consent_signed { Faker::Boolean.boolean }
    meets_project_criteria { Faker::Boolean.boolean }
    clinical_assessment_completed { Faker::Boolean.boolean }
    prolapse_present { Faker::Boolean.boolean }
    stress_test_done { Faker::Boolean.boolean }
    stress_test_result { Faker::Boolean.boolean }
    uti_excluded { Faker::Boolean.boolean }
    bladder_discomfort_vas { Faker::Number.between(from: 0, to: 10) }
    diagnosis { AppointmentFirst.diagnoses.keys.sample }
    alternative_diagnosis { Faker::Lorem.sentence(word_count: 3) }
    oab_treatment_criteria_met { Faker::Boolean.boolean }
    prescribed_medication { AppointmentFirst.prescribed_medications.keys.sample }
    dosage { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    dosage_unit { AppointmentFirst.dosage_units.keys.sample }
    alternative_dosage_unit { Faker::Lorem.word }
    reason_treatment_not_started { AppointmentFirst.reason_treatment_not_starteds.keys.sample }
    alternative_treatment_details { Faker::Lorem.paragraph }
    treatment_contraindications { Faker::Lorem.paragraph }
    follow_up_date { Faker::Time.between(from: Time.current, to: 1.year.from_now) }
    doctor { association :doctor }
    patient { association :patient }
    notes { Faker::Lorem.paragraph }
    blood_in_urine { Faker::Boolean.boolean }
    protein_in_urine { Faker::Boolean.boolean }
    sugar_in_urine { Faker::Boolean.boolean }
    post_void_residual_over_100_ml { Faker::Boolean.boolean }
  end
end
