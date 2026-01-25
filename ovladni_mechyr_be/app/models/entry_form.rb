# frozen_string_literal: true

# == Schema Information
#
# Table name: entry_forms
#
#  id                                  :bigint           not null, primary key
#  urination_frequency_issue           :boolean
#  urinations_per_day                  :integer          not null
#  fluid_intake_volume                 :float            not null

class EntryForm < ApplicationRecord
  validates :urination_frequency_issue, inclusion: { in: [true, false] }
  validates :urinations_per_day, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :fluid_intake_volume, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :patient, optional: true
  def issue_present
    urination_frequency_issue || urinations_per_day > 7
  end
end
