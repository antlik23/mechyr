# frozen_string_literal: true

class Doctor < ApplicationRecord
  belongs_to :user
  has_many :patients
  has_many :appointment_initials
  has_many :appointment_firsts
  has_many :appointment_seconds

  validates :full_name, presence: true

  def is_contactable
    [full_name,
     workplace,
     contact_email,
     contact_phone,
     postal_code,
     street_and_number].all?(&:present?) && full_capacity == false
  end
end
