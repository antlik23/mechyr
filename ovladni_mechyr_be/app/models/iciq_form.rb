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
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#
class IciqForm < ApplicationRecord
  validates :leakage_frequency, inclusion: { in: 0..5 }, allow_nil: true
  validates :leakage_assessment, inclusion: { in: 0..3 }, allow_nil: true
  validates :leakage_severity, inclusion: { in: 0..10 }, allow_nil: true

  belongs_to :patient

  before_save :set_completed

  private

  def set_score
    self.total_score = leakage_frequency.to_i + (leakage_assessment.to_i * 2) + leakage_severity.to_i
  end

  def set_completed
    set_score
    self.completion_timestamp = Time.current
    self.completed = true
  end
end
