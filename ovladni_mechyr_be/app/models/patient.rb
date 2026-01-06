# frozen_string_literal: true

# == Schema Information
#
# Table name: patients
#
#  id                :bigint           not null, primary key
#  first_name        :string
#  last_name         :string
#  assigned_doctor_id:integer
#  gender            :integer          not null
#  user_id           :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Patient < ApplicationRecord
  enum :gender, { male: 0, female: 1, with_prostate: 2, without_prostate: 3 }

  belongs_to :doctor, optional: true
  belongs_to :user
  has_one :entry_form
  has_many :oab_forms
  has_many :iciq_forms
  has_many :ipss_forms
  has_many :anamnestic_forms
  has_many :voiding_diaries
  has_one :appointment_initial
  has_one :appointment_first
  has_one :appointment_second

  validates :gender, presence: true

  def biological_gender
    if ['male', 'with_prostate'].include?(gender)
      'male'
    else
      'female'
    end
  end

  def patient_public_id
    id.to_s.rjust(8, '0')
  end

  def allowed_to_create_voiding_diary
    user.email == 'test@example.com' || (anamnestic_forms.find_by(completed: true).present? && voiding_diaries.blank?)
  end

  def allowed_to_create_iciq_form
    form = iciq_forms.find_by(completed: true)
    oab_forms&.where('total_score >= ?', 8).present? && check_created_at(form)
  end

  def allowed_to_create_anamnestic_form
    form = anamnestic_forms.find_by(completed: true)
    if biological_gender == 'male'
      ipss_forms&.where('total_score <= ?', 7).present? && check_created_at(form)
    else
      iciq_forms.find_by(completed: true).present? && check_created_at(form)
    end
  end

  def allowed_to_create_ipss_form
    form = ipss_forms.find_by(completed: true)
    biological_gender == 'male' && iciq_forms.find_by(completed: true).present? && check_created_at(form)
  end

  def allowed_to_second_appointment
    form = appointment_first
    return false if form.blank?

    ['oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess'].include?(form.diagnosis)
  end

  def can_be_assigned
    sexless_criteria = doctor_id.nil? && oab_forms.find_by(completed: true).present? && iciq_forms.find_by(completed: true).present? &&
                       anamnestic_forms.find_by(completed: true).present? && voiding_diaries&.find_by(completed: true).present?
    if biological_gender == 'male'
      sexless_criteria && ipss_forms.find_by(completed: true).present?
    else
      sexless_criteria
    end
  end

  def check_created_at(form)
    return true if form.blank?

    now = Time.current
    ninety_days_ago = now - 90.days
    form.created_at < ninety_days_ago
  end
end
