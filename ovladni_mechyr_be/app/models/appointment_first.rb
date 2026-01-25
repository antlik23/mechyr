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

class AppointmentFirst < ApplicationRecord
  include Enums

  belongs_to :doctor
  belongs_to :patient

  enum :diagnosis, Enums::DIAGNOSIS
  enum :prescribed_medication, Enums::PRESCRIBED_MEDICATION
  enum :dosage_unit, Enums::DOSAGE_UNIT
  enum :reason_treatment_not_started, Enums::REASON_TREATMENT_NOT_STARTED

  # after_save :update_next_appointment
  # customer changed her mind

  private

  def update_next_appointment
    patient.update(next_appointment: follow_up_date)
  end
end
