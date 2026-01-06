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

class AppointmentSecond < ApplicationRecord
  include Enums

  belongs_to :doctor
  belongs_to :patient

  enum :discontinuation_reason, Enums::DISCONTINUATION_REASON
  enum :current_treatment, Enums::CURRENT_TREATMENT
  enum :prescribed_medication, Enums::PRESCRIBED_MEDICATION_SECOND
  enum :dosage_unit, Enums::DOSAGE_UNIT
  enum :continuing_treatment, Enums::CONTINUING_TREATMENT

  validates :visual_analog_scale, inclusion: { in: 0..10 }, allow_nil: true
end
