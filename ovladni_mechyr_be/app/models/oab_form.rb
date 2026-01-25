# frozen_string_literal: true

# == Schema Information
#
# Table name: oab_forms
#
#  id                         :bigint           not null, primary key
#  daytime_urination_frequency:integer          default(nil)
#  unpleasant_urination_urge  :integer          default(nil)
#  sudden_urination_urge      :integer          default(nil)
#  occasional_leak            :integer          default(nil)
#  nighttime_urination        :integer          default(nil)
#  waking_up_to_urinate       :integer          default(nil)
#  uncontrollable_urge        :integer          default(nil)
#  leak_due_to_intense_urge   :integer          default(nil)
#  total_score                :integer          default(0)
#  completed                  :boolean          default(FALSE)
#  completion_timestamp       :datetime
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
class OabForm < ApplicationRecord
  validates :daytime_urination_frequency, inclusion: { in: 0..5 }, allow_nil: true
  validates :unpleasant_urination_urge, inclusion: { in: 0..5 }, allow_nil: true
  validates :sudden_urination_urge, inclusion: { in: 0..5 }, allow_nil: true
  validates :occasional_leak, inclusion: { in: 0..5 }, allow_nil: true
  validates :nighttime_urination, inclusion: { in: 0..5 }, allow_nil: true
  validates :waking_up_to_urinate, inclusion: { in: 0..5 }, allow_nil: true
  validates :uncontrollable_urge, inclusion: { in: 0..5 }, allow_nil: true
  validates :leak_due_to_intense_urge, inclusion: { in: 0..5 }, allow_nil: true

  belongs_to :patient

  before_save :set_completed

  private

  def set_score
    self.total_score = daytime_urination_frequency.to_i +
                       unpleasant_urination_urge.to_i +
                       sudden_urination_urge.to_i +
                       occasional_leak.to_i +
                       nighttime_urination.to_i +
                       waking_up_to_urinate.to_i +
                       uncontrollable_urge.to_i +
                       leak_due_to_intense_urge.to_i
    self.total_score += 2 if patient.biological_gender == 'male'
  end

  def set_completed
    set_score
    self.completion_timestamp = Time.current
    self.completed = true
  end
end
