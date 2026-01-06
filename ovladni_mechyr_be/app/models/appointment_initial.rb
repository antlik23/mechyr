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

class AppointmentInitial < ApplicationRecord
  include Enums

  belongs_to :doctor
  belongs_to :patient

  enum :diagnosis, Enums::DIAGNOSIS, _suffix: true
  enum :prescribed_medication, Enums::PRESCRIBED_MEDICATION, _suffix: true
  enum :dosage_unit, Enums::DOSAGE_UNIT, _suffix: true
  enum :reason_treatment_not_started, Enums::REASON_TREATMENT_NOT_STARTED_INITIAL, _suffix: true
end
