# frozen_string_literal: true

# == Schema Information
#
# Table name: voiding_records
#
#  id                         :bigint           not null, primary key
#  recorded_at                :datetime
#  slept_before_and_after     :boolean
#  urine_leakage              :boolean
#  urine_leakage_type         :integer
#  urge_strength              :integer
#  urine_volume               :integer
#  beverage_type              :integer
#  fluid_intake               :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null

class VoidingRecord < ApplicationRecord
  belongs_to :voiding_diary

  validates :recorded_at, presence: true
  validates :urge_strength, inclusion: { in: 0..4 }, allow_nil: true

  enum :beverage_type, { clear_water: 0, fizzy_water: 1, mineral_water: 2, hot_beverage: 3, sweet_drink: 4, citrus_drink: 5, alcohol: 6, other: 7 }
  enum :urine_leakage_type, { stressful: 0, urgent: 1 }

  def record_type
    if urine_volume.present?
      'output'
    else
      'input'
    end
  end
end
