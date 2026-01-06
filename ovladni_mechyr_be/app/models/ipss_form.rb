# frozen_string_literal: true

# == Schema Information
#
# Table name: ipss_forms
#
#  id                         :bigint           not null, primary key
#  incomplete_emptying        :integer
#  frequency                  :integer
#  intermittent_urination     :integer
#  urgency                    :integer
#  weak_stream                :integer
#  straining                  :integer
#  nocturnal_urination        :integer
#  total_score                :integer
#  quality_of_life            :integer
#  completed                  :boolean          default(FALSE)
#  completion_timestamp       :datetime
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
class IpssForm < ApplicationRecord
  validates :incomplete_emptying, inclusion: { in: 0..5 }, allow_nil: true
  validates :frequency, inclusion: { in: 0..5 }, allow_nil: true
  validates :intermittent_urination, inclusion: { in: 0..5 }, allow_nil: true
  validates :urgency, inclusion: { in: 0..5 }, allow_nil: true
  validates :weak_stream, inclusion: { in: 0..5 }, allow_nil: true
  validates :straining, inclusion: { in: 0..5 }, allow_nil: true
  validates :nocturnal_urination, inclusion: { in: 0..5 }, allow_nil: true
  validates :quality_of_life, inclusion: { in: 0..6 }, allow_nil: true

  belongs_to :patient

  before_save :set_completed

  private

  def set_score
    self.total_score = incomplete_emptying.to_i +
                       frequency.to_i +
                       intermittent_urination.to_i +
                       urgency.to_i +
                       weak_stream.to_i +
                       straining.to_i +
                       nocturnal_urination.to_i
  end

  def set_completed
    set_score
    self.completion_timestamp = Time.current
    self.completed = true
  end
end
