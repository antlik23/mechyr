# frozen_string_literal: true

class Doctor < ApplicationRecord
  # Úkol 12: Enum pro specializaci lékaře
  enum :specialization, {
    general: 0,           # všichni pacienti
    urologist: 1,         # muži (male, with_prostate)
    gynecologist: 2,      # ženy (female, without_prostate)
    urogynecologist: 3    # všichni pacienti
  }

  belongs_to :user
  has_many :patients
  has_many :appointment_initials
  has_many :appointment_firsts
  has_many :appointment_seconds

  validates :full_name, presence: true

  # Úkol 12: Scope pro filtraci lékařů podle pohlaví pacienta
  scope :for_patient, lambda { |patient|
    return all if patient.nil?

    biological_gender = patient.biological_gender

    if biological_gender == 'male'
      # Muži → urolog, general, urogynecolog
      where(specialization: %i[general urologist urogynecologist])
    elsif biological_gender == 'female'
      # Ženy → gynekolog, general, urogynecolog
      where(specialization: %i[general gynecologist urogynecologist])
    else
      all
    end
  }

  def is_contactable
    [full_name,
     workplace,
     contact_email,
     contact_phone,
     postal_code,
     street_and_number].all?(&:present?) && full_capacity == false
  end
end
