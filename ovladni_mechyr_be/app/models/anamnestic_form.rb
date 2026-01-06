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
#  on_oab_medication_last_3_months     :boolean
#  number_of_births                    :integer
#  post_menopausal                     :boolean
#  prolapse_diagnosed                  :boolean
#  hysterectomy                        :boolean
#  cesarean_section                    :boolean
#  surgery_for_benign_prostate_enlargement:boolean
#  surgery_for_prostate_cancer         :boolean
#  surgery_for_bladder_tumor           :boolean
#  surgery_for_urethral_stricture      :boolean
#  surgery_for_urine_leakage           :boolean
#  other_surgery                       :boolean
#  previous_surgery_details            :string
#  recurrent_infections                :boolean
#  neurological_surgery_history         :boolean
#  hypertension                        :boolean
#  hypothyroidism                      :boolean
#  high_cholesterol                    :boolean
#  diabetes                            :boolean
#  back_problems                       :boolean
#  depression                          :boolean
#  other_psychiatric_conditions        :boolean
#  reduced_immunity                    :boolean
#  headaches                           :boolean
#  hip_osteoarthritis                  :boolean
#  knee_osteoarthritis                 :boolean
#  cancer_treatment_history            :boolean
#  cervical_cancer                     :boolean
#  endometrial_cancer                  :boolean
#  ovarian_cancer                      :boolean
#  breast_cancer                       :boolean
#  intestinal_cancer                   :boolean
#  other_cancer                        :boolean
#  cancer_type_details                 :string
#  drug_allergies                      :boolean
#  drug_allergies_details              :string
#  glaucoma_or_eye_pressure_meds       :boolean
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
class AnamnesticForm < ApplicationRecord
  belongs_to :patient
  enum :cesarean_section, { false: 0, true: 1, no_birth: 2 }

  before_save :set_completed

  private

  def set_completed
    self.completion_timestamp = Time.current
    self.completed = true
  end
end
