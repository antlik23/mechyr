# frozen_string_literal: true

# == Schema Information
#
# Table name: anamnestic_forms
#
#  id                                  :bigint           not null, primary key
#  completion_timestamp                :datetime
#  age                                 :integer
#  height                              :integer
#  weight                              :integer
#  on_oab_medication_last_3_months    :boolean
#  number_of_births                    :integer
#  post_menopausal                     :boolean
#  prolapse_diagnosed                  :boolean
#  hysterectomy                        :boolean
#  cesarean_section                    :boolean
#  surgery_for_benign_prostate_enlargement:boolean
#  surgery_for_prostate_cancer        :boolean
#  surgery_for_bladder_tumor          :boolean
#  surgery_for_urethral_stricture      :boolean
#  surgery_for_urine_leakage          :boolean
#  other_surgery                       :boolean
#  previous_surgery_details            :string
#  recurrent_infections                :boolean
#  neurological_surgery_history         :boolean
#  hypertension                        :boolean
#  hypothyroidism                      :boolean
#  high_cholesterol                    :boolean
#  diabetes                           :boolean
#  back_problems                       :boolean
#  depression                          :boolean
#  other_psychiatric_conditions       :boolean
#  reduced_immunity                    :boolean
#  headaches                           :boolean
#  hip_osteoarthritis                  :boolean
#  knee_osteoarthritis                 :boolean
#  cancer_treatment_history           :boolean
#  cervical_cancer                     :boolean
#  endometrial_cancer                  :boolean
#  ovarian_cancer                      :boolean
#  breast_cancer                       :boolean
#  intestinal_cancer                   :boolean
#  other_cancer                        :boolean
#  cancer_type_details                 :string
#  drug_allergies                      :boolean
#  drug_allergies_details              :string
#  glaucoma_or_eye_pressure_meds      :boolean
#  cardiac_conditions                  :boolean
#  heart_attack                        :boolean
#  arrhythmia                          :boolean
#  stroke                              :boolean
#  digestive_problems                  :boolean
#  dry_mucous_membranes                :boolean
#  current_medications                 :boolean
#  current_medications_details         :string
#  past_medications                    :boolean
#  past_medications_details            :string
#  completed                           :boolean
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#

FactoryBot.define do
  factory :anamnestic_form do
    completion_timestamp { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    age { Faker::Number.between(from: 18, to: 100) }
    height { Faker::Number.between(from: 140, to: 200) }
    weight { Faker::Number.between(from: 40, to: 150) }
    on_oab_medication_last_3_months { Faker::Boolean.boolean }
    number_of_births { Faker::Number.between(from: 0, to: 5) }
    post_menopausal { Faker::Boolean.boolean }
    prolapse_diagnosed { Faker::Boolean.boolean }
    hysterectomy { Faker::Boolean.boolean }
    cesarean_section { AnamnesticForm.cesarean_sections.keys.sample }
    surgery_for_benign_prostate_enlargement { Faker::Boolean.boolean }
    surgery_for_prostate_cancer { Faker::Boolean.boolean }
    surgery_for_bladder_tumor { Faker::Boolean.boolean }
    surgery_for_urethral_stricture { Faker::Boolean.boolean }
    surgery_for_urine_leakage { Faker::Boolean.boolean }
    other_surgery { Faker::Boolean.boolean }
    previous_surgery_details { Faker::Lorem.sentence }
    recurrent_infections { Faker::Boolean.boolean }
    neurological_surgery_history { Faker::Boolean.boolean }
    hypertension { Faker::Boolean.boolean }
    hypothyroidism { Faker::Boolean.boolean }
    high_cholesterol { Faker::Boolean.boolean }
    diabetes { Faker::Boolean.boolean }
    back_problems { Faker::Boolean.boolean }
    depression { Faker::Boolean.boolean }
    other_psychiatric_conditions { Faker::Boolean.boolean }
    reduced_immunity { Faker::Boolean.boolean }
    headaches { Faker::Boolean.boolean }
    hip_osteoarthritis { Faker::Boolean.boolean }
    knee_osteoarthritis { Faker::Boolean.boolean }
    cancer_treatment_history { Faker::Boolean.boolean }
    cervical_cancer { Faker::Boolean.boolean }
    endometrial_cancer { Faker::Boolean.boolean }
    ovarian_cancer { Faker::Boolean.boolean }
    breast_cancer { Faker::Boolean.boolean }
    intestinal_cancer { Faker::Boolean.boolean }
    other_cancer { Faker::Boolean.boolean }
    cancer_type_details { Faker::Lorem.sentence }
    drug_allergies { Faker::Boolean.boolean }
    drug_allergies_details { Faker::Lorem.sentence }
    glaucoma_or_eye_pressure_meds { Faker::Boolean.boolean }
    cardiac_conditions { Faker::Boolean.boolean }
    heart_attack { Faker::Boolean.boolean }
    arrhythmia { Faker::Boolean.boolean }
    stroke { Faker::Boolean.boolean }
    digestive_problems { Faker::Boolean.boolean }
    dry_mucous_membranes { Faker::Boolean.boolean }
    current_medications { Faker::Boolean.boolean }
    current_medications_details { Faker::Lorem.sentence }
    past_medications { Faker::Boolean.boolean }
    past_medications_details { Faker::Lorem.sentence }
    completed { Faker::Boolean.boolean }
    patient { association :patient }
    no_surgery { Faker::Boolean.boolean }
    no_illness { Faker::Boolean.boolean }
  end
end
