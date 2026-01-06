# frozen_string_literal: true

# == Schema Information
#
# Table name: voiding_diaries
#
#  id                         :bigint           not null, primary key
#  diary_start_date           :date
#  diary_duration_days        :integer
#  usual_bedtime              :time
#  usual_wake_up_time         :time
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null

class VoidingDiary < ApplicationRecord
  belongs_to :patient
  has_many :voiding_records

  validates :diary_start_date, presence: true
  validates :diary_duration_days, inclusion: { in: 1..2 }, presence: true

  def fluid_intake_volume
    voiding_records.sum(:fluid_intake)
  end

  def voided_volume
    voiding_records.sum(:urine_volume)
  end

  def nocturnal_voided_volume
    voiding_records.where(slept_before_and_after: true).sum(:urine_volume)
  end

  def polyuria
    voiding_records.sum(:urine_volume) / patient.anamnestic_forms.last.weight > 40
  end

  def nocturnal_polyuria_index
    nocturnal_voided_volume = voiding_records.where(slept_before_and_after: true).sum(:urine_volume)
    return 0 if nocturnal_voided_volume.zero?

    (nocturnal_voided_volume.to_f / voiding_records.sum(:urine_volume) * 100).to_i
  end

  def urination_frequency
    voiding_records.where('urine_volume > 0').count
  end

  def nocturnal_voids
    voiding_records.where(slept_before_and_after: true).count
  end

  def urgencies
    voiding_records.where(urge_strength: 3..4).count
  end

  def urgent_incontinence
    voiding_records.where(urine_leakage_type: 1).count
  end

  def incontinence_episodes
    voiding_records.where(urine_leakage: true).count
  end

  def max_voided_volume
    max = voiding_records.maximum(:urine_volume)
    max || 0
  end

  def median_voided_volume
    urine_volumes = voiding_records.where('urine_volume > 0').order(:urine_volume).pluck(:urine_volume)

    count = urine_volumes.length

    return 0 if count.zero?

    midpoint = count / 2

    if count.even?
      (urine_volumes[midpoint - 1] + urine_volumes[midpoint]) / 2.0
    else
      urine_volumes[midpoint]
    end
  end

  def average_voided_volume
    voiding_records.average(:urine_volume).to_i
  end
end
