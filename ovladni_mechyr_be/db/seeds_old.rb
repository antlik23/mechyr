# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

unless Rails.env.production?
  # Create roles first
  Role.find_or_create_by!(name: 'patient')
  Role.find_or_create_by!(name: 'doctor')
  Role.find_or_create_by!(name: 'admin')

  10.times do |i|

    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    full_name = "#{first_name} #{last_name}"
    email = "patient#{i+1}@example.com"
    password = "test123"



    User.find_or_create_by!(email: email) do |user|
      user.password = password
      user.password_confirmation = password
      user.confirmed_at = Time.current
      patient = Patient.create!(full_name: full_name, user: user, gender: "male")
      UsersRole.create!(user_id: user.id, role_id: Role.find_by(name: 'patient').id)
      OabForm.create!(
        patient: patient,

        daytime_urination_frequency: Faker::Number.between(from: 2, to: 5),
        unpleasant_urination_urge: Faker::Number.between(from: 2, to: 5),
        sudden_urination_urge: Faker::Number.between(from: 2, to: 5),
        occasional_leak: Faker::Number.between(from: 2, to: 5),
        nighttime_urination: Faker::Number.between(from: 2, to: 5),
        waking_up_to_urinate: Faker::Number.between(from: 2, to: 5),
        uncontrollable_urge: Faker::Number.between(from: 2, to: 5),
        leak_due_to_intense_urge: Faker::Number.between(from: 2, to: 5),

        total_score: 25,

        completed: true,
        completion_timestamp: Faker::Time.between(from: 1.year.ago, to: Time.now),
        created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
      )
      EntryForm.create!(
        patient: patient,

        urination_frequency_issue: Faker::Boolean.boolean(true_ratio: 0.4), # 40% chance of having an issue
        urinations_per_day: Faker::Number.between(from: 4, to: 15), # Typical range for urinations per day
        fluid_intake_volume: Faker::Number.between(from: 1.0, to: 4.0).round(1), # Liters, e.g., 1.5, 3.2
        created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
      )
      IciqForm.create!(
        patient: patient,

        leakage_frequency: Faker::Number.between(from: 0, to: 5),
        leakage_assessment: Faker::Number.between(from: 0, to: 0),
        leakage_severity: Faker::Number.between(from: 0, to: 10),

        # Boolean fields related to leakage circumstances
        never_leaks: Faker::Boolean.boolean(true_ratio: 0.2), # 20% chance of never leaking
        leaks_before_reaching_toilet: Faker::Boolean.boolean(true_ratio: 0.3),
        leaks_when_coughing_or_sneezing: Faker::Boolean.boolean(true_ratio: 0.4),
        leaks_during_sleep: Faker::Boolean.boolean(true_ratio: 0.1),
        leaks_during_physical_activity: Faker::Boolean.boolean(true_ratio: 0.35),
        leaks_after_urinating_and_dressing: Faker::Boolean.boolean(true_ratio: 0.2),
        leaks_for_unknown_reasons: Faker::Boolean.boolean(true_ratio: 0.15),
        constant_leakage: Faker::Boolean.boolean(true_ratio: 0.05),

        total_score: 15,
        completed: true,
        completion_timestamp: Faker::Time.between(from: 1.year.ago, to: Time.now),
        created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
      )
      IpssForm.create!(
        patient: patient,

        incomplete_emptying: Faker::Number.between(from: 0, to: 1),
        frequency: Faker::Number.between(from: 0, to: 1),
        intermittent_urination: Faker::Number.between(from: 0, to: 1),
        urgency: Faker::Number.between(from: 0, to: 1),
        weak_stream: Faker::Number.between(from: 0, to: 1),
        straining: Faker::Number.between(from: 0, to: 1),
        nocturnal_urination: Faker::Number.between(from: 0, to: 1),

        total_score: 5,
        quality_of_life: Faker::Number.between(from: 0, to: 6),

        completed: true,
        completion_timestamp: Faker::Time.between(from: 1.year.ago, to: Time.now),
        created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
      )
      AnamnesticForm.create!(
        patient: patient,

        completion_timestamp: Faker::Time.between(from: 2.years.ago, to: Time.now),
        age: Faker::Number.between(from: 18, to: 90),
        height: Faker::Number.between(from: 150, to: 190), # cm
        weight: Faker::Number.between(from: 45, to: 120), # kg

        # Boolean fields - use Faker::Boolean.boolean for true/false randomization
        on_oab_medication_last_3_months: Faker::Boolean.boolean(true_ratio: 0.2), # Less likely to be true
        number_of_births: Faker::Number.between(from: 0, to: 5),
        post_menopausal: Faker::Boolean.boolean(true_ratio: 0.5),
        prolapse_diagnosed: Faker::Boolean.boolean(true_ratio: 0.1),
        hysterectomy: Faker::Boolean.boolean(true_ratio: 0.15),
        cesarean_section: Faker::Number.between(from: 0, to: 2),

        # Surgeries
        surgery_for_benign_prostate_enlargement: Faker::Boolean.boolean(true_ratio: 0.05),
        surgery_for_prostate_cancer: Faker::Boolean.boolean(true_ratio: 0.03),
        surgery_for_bladder_tumor: Faker::Boolean.boolean(true_ratio: 0.02),
        surgery_for_urethral_stricture: Faker::Boolean.boolean(true_ratio: 0.01),
        surgery_for_urine_leakage: Faker::Boolean.boolean(true_ratio: 0.05),
        other_surgery: Faker::Boolean.boolean(true_ratio: 0.1),
        # Conditional detail fields: only fill if the corresponding boolean is true
        previous_surgery_details: Faker::Boolean.boolean(true_ratio: 0.1) ? Faker::Lorem.sentence(word_count: 5) : nil,
        no_surgery: Faker::Boolean.boolean(true_ratio: 0.5), # Assuming this means no surgeries at all

        # Illnesses/Conditions
        recurrent_infections: Faker::Boolean.boolean(true_ratio: 0.2),
        neurological_surgery_history: Faker::Boolean.boolean(true_ratio: 0.05),
        hypertension: Faker::Boolean.boolean(true_ratio: 0.3),
        hypothyroidism: Faker::Boolean.boolean(true_ratio: 0.1),
        high_cholesterol: Faker::Boolean.boolean(true_ratio: 0.25),
        diabetes: Faker::Boolean.boolean(true_ratio: 0.15),
        back_problems: Faker::Boolean.boolean(true_ratio: 0.2),
        depression: Faker::Boolean.boolean(true_ratio: 0.2),
        other_psychiatric_conditions: Faker::Boolean.boolean(true_ratio: 0.08),
        reduced_immunity: Faker::Boolean.boolean(true_ratio: 0.05),
        headaches: Faker::Boolean.boolean(true_ratio: 0.3),
        hip_osteoarthritis: Faker::Boolean.boolean(true_ratio: 0.1),
        knee_osteoarthritis: Faker::Boolean.boolean(true_ratio: 0.1),
        no_illness: Faker::Boolean.boolean(true_ratio: 0.4), # Assuming this means no illnesses at all

        # Cancer History
        cancer_treatment_history: Faker::Boolean.boolean(true_ratio: 0.1),
        cervical_cancer: Faker::Boolean.boolean(true_ratio: 0.01),
        endometrial_cancer: Faker::Boolean.boolean(true_ratio: 0.01),
        ovarian_cancer: Faker::Boolean.boolean(true_ratio: 0.01),
        breast_cancer: Faker::Boolean.boolean(true_ratio: 0.05),
        intestinal_cancer: Faker::Boolean.boolean(true_ratio: 0.02),
        other_cancer: Faker::Boolean.boolean(true_ratio: 0.03),
        cancer_type_details: Faker::Boolean.boolean(true_ratio: 0.05) ? Faker::Lorem.sentence(word_count: 4) : nil,

        # Allergies & Other Conditions
        drug_allergies: Faker::Boolean.boolean(true_ratio: 0.15),
        drug_allergies_details: Faker::Boolean.boolean(true_ratio: 0.1) ? Faker::Lorem.sentence(word_count: 6) : nil,
        glaucoma_or_eye_pressure_meds: Faker::Boolean.boolean(true_ratio: 0.05),
        cardiac_conditions: Faker::Boolean.boolean(true_ratio: 0.15),
        heart_attack: Faker::Boolean.boolean(true_ratio: 0.05),
        arrhythmia: Faker::Boolean.boolean(true_ratio: 0.07),
        stroke: Faker::Boolean.boolean(true_ratio: 0.03),
        digestive_problems: Faker::Boolean.boolean(true_ratio: 0.2),
        dry_mucous_membranes: Faker::Boolean.boolean(true_ratio: 0.1),

        # Medications
        current_medications: Faker::Boolean.boolean(true_ratio: 0.3),
        current_medications_details: Faker::Boolean.boolean(true_ratio: 0.2) ? Faker::Lorem.paragraph(sentence_count: 2) : nil,
        past_medications: Faker::Boolean.boolean(true_ratio: 0.2),
        past_medications_details: Faker::Boolean.boolean(true_ratio: 0.15) ? Faker::Lorem.paragraph(sentence_count: 2) : nil,

        completed: true
      )
      diary = VoidingDiary.create!(
        patient: patient,

        diary_start_date: Faker::Date.between(from: Date.today, to: 7.days.from_now),
        diary_duration_days: 1,
        bedtime_day_one: "20:30",
        wake_up_time_day_one: "7:30",
        created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        completed: true
      )

      10.times do |i|
        VoidingRecord.create!(
          voiding_diary: diary,
          recorded_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
          slept_before_and_after: Faker::Boolean.boolean(true_ratio: 0.4),
          urine_leakage: Faker::Boolean.boolean(true_ratio: 0.2),
          urge_strength: Faker::Number.between(from: 0, to: 4),
          urine_volume: Faker::Number.between(from: 50, to: 200),
          urine_leakage_type: "stressful"
        )

        VoidingRecord.create!(
          voiding_diary: diary,
          recorded_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
          urge_strength: Faker::Number.between(from: 0, to: 4),
          fluid_intake: Faker::Number.between(from: 50, to: 200),
          beverage_type: "clear_water"
        )
      end
    end
  end

  10.times do |i|

    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    full_name = "#{first_name} #{last_name}"
    email = "patient#{i+11}@example.com"
    password = "test123"

    User.find_or_create_by!(email: email) do |user|
      user.password = password
      user.password_confirmation = password
      user.email = email
      user.confirmed_at = Time.current
      patient = Patient.create!(full_name: full_name, user: user, gender: "female")
      UsersRole.create!(user_id: user.id, role_id: Role.find_by(name: 'patient').id)
      OabForm.create!(
        patient: patient,

        daytime_urination_frequency: Faker::Number.between(from: 2, to: 5),
        unpleasant_urination_urge: Faker::Number.between(from: 2, to: 5),
        sudden_urination_urge: Faker::Number.between(from: 2, to: 5),
        occasional_leak: Faker::Number.between(from: 2, to: 5),
        nighttime_urination: Faker::Number.between(from: 2, to: 5),
        waking_up_to_urinate: Faker::Number.between(from: 2, to: 5),
        uncontrollable_urge: Faker::Number.between(from: 2, to: 5),
        leak_due_to_intense_urge: Faker::Number.between(from: 2, to: 5),

        total_score: 25,

        completed: true,
        completion_timestamp: Faker::Time.between(from: 1.year.ago, to: Time.now),
        created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
      )
      EntryForm.create!(
        patient: patient,

        urination_frequency_issue: Faker::Boolean.boolean(true_ratio: 0.4), # 40% chance of having an issue
        urinations_per_day: Faker::Number.between(from: 4, to: 15), # Typical range for urinations per day
        fluid_intake_volume: Faker::Number.between(from: 1.0, to: 4.0).round(1), # Liters, e.g., 1.5, 3.2
        created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
      )
      IpssForm.create!(
        patient: patient,

        incomplete_emptying: Faker::Number.between(from: 0, to: 1),
        frequency: Faker::Number.between(from: 0, to: 1),
        intermittent_urination: Faker::Number.between(from: 0, to: 1),
        urgency: Faker::Number.between(from: 0, to: 1),
        weak_stream: Faker::Number.between(from: 0, to: 1),
        straining: Faker::Number.between(from: 0, to: 1),
        nocturnal_urination: Faker::Number.between(from: 0, to: 1),

        total_score: 5,
        quality_of_life: Faker::Number.between(from: 0, to: 5),

        completed: true,
        completion_timestamp: Faker::Time.between(from: 1.year.ago, to: Time.now),
        created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
      )
      AnamnesticForm.create!(
        patient: patient,

        completion_timestamp: Faker::Time.between(from: 2.years.ago, to: Time.now),
        age: Faker::Number.between(from: 18, to: 90),
        height: Faker::Number.between(from: 150, to: 190), # cm
        weight: Faker::Number.between(from: 45, to: 120), # kg

        # Boolean fields - use Faker::Boolean.boolean for true/false randomization
        on_oab_medication_last_3_months: Faker::Boolean.boolean(true_ratio: 0.2), # Less likely to be true
        number_of_births: Faker::Number.between(from: 0, to: 5),
        post_menopausal: Faker::Boolean.boolean(true_ratio: 0.5),
        prolapse_diagnosed: Faker::Boolean.boolean(true_ratio: 0.1),
        hysterectomy: Faker::Boolean.boolean(true_ratio: 0.15),
        cesarean_section: Faker::Number.between(from: 0, to: 2),

        # Surgeries
        surgery_for_benign_prostate_enlargement: Faker::Boolean.boolean(true_ratio: 0.05),
        surgery_for_prostate_cancer: Faker::Boolean.boolean(true_ratio: 0.03),
        surgery_for_bladder_tumor: Faker::Boolean.boolean(true_ratio: 0.02),
        surgery_for_urethral_stricture: Faker::Boolean.boolean(true_ratio: 0.01),
        surgery_for_urine_leakage: Faker::Boolean.boolean(true_ratio: 0.05),
        other_surgery: Faker::Boolean.boolean(true_ratio: 0.1),
        # Conditional detail fields: only fill if the corresponding boolean is true
        previous_surgery_details: Faker::Boolean.boolean(true_ratio: 0.1) ? Faker::Lorem.sentence(word_count: 5) : nil,
        no_surgery: Faker::Boolean.boolean(true_ratio: 0.5), # Assuming this means no surgeries at all

        # Illnesses/Conditions
        recurrent_infections: Faker::Boolean.boolean(true_ratio: 0.2),
        neurological_surgery_history: Faker::Boolean.boolean(true_ratio: 0.05),
        hypertension: Faker::Boolean.boolean(true_ratio: 0.3),
        hypothyroidism: Faker::Boolean.boolean(true_ratio: 0.1),
        high_cholesterol: Faker::Boolean.boolean(true_ratio: 0.25),
        diabetes: Faker::Boolean.boolean(true_ratio: 0.15),
        back_problems: Faker::Boolean.boolean(true_ratio: 0.2),
        depression: Faker::Boolean.boolean(true_ratio: 0.2),
        other_psychiatric_conditions: Faker::Boolean.boolean(true_ratio: 0.08),
        reduced_immunity: Faker::Boolean.boolean(true_ratio: 0.05),
        headaches: Faker::Boolean.boolean(true_ratio: 0.3),
        hip_osteoarthritis: Faker::Boolean.boolean(true_ratio: 0.1),
        knee_osteoarthritis: Faker::Boolean.boolean(true_ratio: 0.1),
        no_illness: Faker::Boolean.boolean(true_ratio: 0.4), # Assuming this means no illnesses at all

        # Cancer History
        cancer_treatment_history: Faker::Boolean.boolean(true_ratio: 0.1),
        cervical_cancer: Faker::Boolean.boolean(true_ratio: 0.01),
        endometrial_cancer: Faker::Boolean.boolean(true_ratio: 0.01),
        ovarian_cancer: Faker::Boolean.boolean(true_ratio: 0.01),
        breast_cancer: Faker::Boolean.boolean(true_ratio: 0.05),
        intestinal_cancer: Faker::Boolean.boolean(true_ratio: 0.02),
        other_cancer: Faker::Boolean.boolean(true_ratio: 0.03),
        cancer_type_details: Faker::Boolean.boolean(true_ratio: 0.05) ? Faker::Lorem.sentence(word_count: 4) : nil,

        # Allergies & Other Conditions
        drug_allergies: Faker::Boolean.boolean(true_ratio: 0.15),
        drug_allergies_details: Faker::Boolean.boolean(true_ratio: 0.1) ? Faker::Lorem.sentence(word_count: 6) : nil,
        glaucoma_or_eye_pressure_meds: Faker::Boolean.boolean(true_ratio: 0.05),
        cardiac_conditions: Faker::Boolean.boolean(true_ratio: 0.15),
        heart_attack: Faker::Boolean.boolean(true_ratio: 0.05),
        arrhythmia: Faker::Boolean.boolean(true_ratio: 0.07),
        stroke: Faker::Boolean.boolean(true_ratio: 0.03),
        digestive_problems: Faker::Boolean.boolean(true_ratio: 0.2),
        dry_mucous_membranes: Faker::Boolean.boolean(true_ratio: 0.1),

        # Medications
        current_medications: Faker::Boolean.boolean(true_ratio: 0.3),
        current_medications_details: Faker::Boolean.boolean(true_ratio: 0.2) ? Faker::Lorem.paragraph(sentence_count: 2) : nil,
        past_medications: Faker::Boolean.boolean(true_ratio: 0.2),
        past_medications_details: Faker::Boolean.boolean(true_ratio: 0.15) ? Faker::Lorem.paragraph(sentence_count: 2) : nil,

        completed: true
      )

      diary = VoidingDiary.create!(
        patient: patient,

        diary_start_date: Faker::Date.between(from: Date.today, to: 7.days.from_now),
        diary_duration_days: 1,
        bedtime_day_one: "20:30",
        wake_up_time_day_one: "7:30",
        created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
        completed: true
      )

      10.times do |i|
        VoidingRecord.create!(
          voiding_diary: diary,
          recorded_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
          slept_before_and_after: Faker::Boolean.boolean(true_ratio: 0.4),
          urine_leakage: Faker::Boolean.boolean(true_ratio: 0.2),
          urge_strength: Faker::Number.between(from: 0, to: 4),
          urine_volume: Faker::Number.between(from: 50, to: 200),
          urine_leakage_type: "stressful"
        )

        VoidingRecord.create!(
          voiding_diary: diary,
          recorded_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
          urge_strength: Faker::Number.between(from: 0, to: 4),
          fluid_intake: Faker::Number.between(from: 50, to: 200),
          beverage_type: "clear_water"
        )
      end

    end
  end

  # Ensure dev seed users are always able to log in (Devise :confirmable)
  (1..20).each do |i|
    User.where(email: "patient#{i}@example.com", confirmed_at: nil).update_all(confirmed_at: Time.current)
  end
end


admin_user = User.find_or_create_by!(email: 'admin@test.com') do |user|
  user.first_name = 'John'
  user.last_name = 'Doe'
  user.password = 'test123'
  user.password_confirmation = 'test123'
  user.confirmed_at = Time.current
  user.add_role(Role::ADMIN)
end

admin_user.update!(confirmed_at: Time.current) if admin_user.confirmed_at.nil?
admin_user.add_role(Role::ADMIN) unless admin_user.has_role?(Role::ADMIN)

# ============================================================================
# TESTOVACÍ DATA PRO ÚKOL 1: Datum návštěvy pacienta
# ============================================================================

# Vytvoř testovacího doktora (galeologu)
test_doctor_user = User.find_or_create_by!(email: 'doctor.test@example.com') do |user|
  user.first_name = 'MUDr.'
  user.last_name = 'Testovací'
  user.password = 'test123'
  user.password_confirmation = 'test123'
  user.confirmed_at = Time.current
end

test_doctor_user.update!(confirmed_at: Time.current) if test_doctor_user.confirmed_at.nil?
test_doctor_user.add_role(Role::DOCTOR) unless test_doctor_user.has_role?(Role::DOCTOR)

test_doctor = Doctor.find_or_create_by!(user_id: test_doctor_user.id) do |doctor|
  doctor.full_name = 'MUDr. Testovací'
  doctor.contact_email = 'doctor.test@example.com'
  doctor.contact_phone = '+420 123 456 789'
  doctor.workplace = 'Testovací urologická klinika'
  doctor.city = 'Praha'
  doctor.postal_code = '110 00'
  doctor.street_and_number = 'Testovací 123'
  doctor.full_capacity = false
  doctor.specialization = :urogynecologist
end

# Update existing doctor if fields are missing
test_doctor.update!(
  workplace: 'Testovací urologická klinika',
  city: 'Praha',
  postal_code: '110 00',
  street_and_number: 'Testovací 123',
  full_capacity: false,
  specialization: :urogynecologist
) if test_doctor.workplace.nil?

# Vytvoř testovacího pacienta s vyplenými appointment záznamy
test_patient_user = User.find_or_create_by!(email: 'patient.test.appointments@example.com') do |user|
  user.password = 'test123'
  user.password_confirmation = 'test123'
  user.confirmed_at = Time.current
end

test_patient_user.update!(confirmed_at: Time.current) if test_patient_user.confirmed_at.nil?
test_patient_user.add_role(Role::PATIENT) unless test_patient_user.has_role?(Role::PATIENT)

test_patient = Patient.find_or_create_by!(user_id: test_patient_user.id) do |patient|
  patient.full_name = 'Testovací Pacient'
  patient.gender = 'female'
  patient.doctor = test_doctor
end

# Vytvoř dotazníky pro testovacího pacienta
OabForm.find_or_create_by!(patient_id: test_patient.id) do |form|
  form.daytime_urination_frequency = 3
  form.unpleasant_urination_urge = 4
  form.sudden_urination_urge = 4
  form.occasional_leak = 3
  form.nighttime_urination = 3
  form.waking_up_to_urinate = 4
  form.uncontrollable_urge = 4
  form.leak_due_to_intense_urge = 3
  form.total_score = 28
  form.completed = true
  form.completion_timestamp = 30.days.ago
end

IciqForm.find_or_create_by!(patient_id: test_patient.id) do |form|
  form.leakage_frequency = 3
  form.leakage_assessment = 0
  form.leakage_severity = 6
  form.never_leaks = false
  form.leaks_before_reaching_toilet = true
  form.leaks_when_coughing_or_sneezing = true
  form.leaks_during_sleep = false
  form.leaks_during_physical_activity = true
  form.leaks_after_urinating_and_dressing = false
  form.leaks_for_unknown_reasons = false
  form.constant_leakage = false
  form.total_score = 9
  form.completed = true
  form.completion_timestamp = 29.days.ago
end

AnamnesticForm.find_or_create_by!(patient_id: test_patient.id) do |form|
  form.completion_timestamp = 28.days.ago
  form.age = 45
  form.height = 165
  form.weight = 70
  form.on_oab_medication_last_3_months = false
  form.number_of_births = 2
  form.post_menopausal = false
  form.prolapse_diagnosed = false
  form.hysterectomy = false
  form.cesarean_section = 0
  form.surgery_for_benign_prostate_enlargement = false
  form.surgery_for_prostate_cancer = false
  form.surgery_for_bladder_tumor = false
  form.surgery_for_urethral_stricture = false
  form.surgery_for_urine_leakage = false
  form.other_surgery = false
  form.no_surgery = true
  form.recurrent_infections = false
  form.neurological_surgery_history = false
  form.hypertension = false
  form.hypothyroidism = false
  form.high_cholesterol = false
  form.diabetes = false
  form.back_problems = false
  form.depression = false
  form.other_psychiatric_conditions = false
  form.reduced_immunity = false
  form.headaches = false
  form.hip_osteoarthritis = false
  form.knee_osteoarthritis = false
  form.no_illness = true
  form.cancer_treatment_history = false
  form.cervical_cancer = false
  form.endometrial_cancer = false
  form.ovarian_cancer = false
  form.breast_cancer = false
  form.intestinal_cancer = false
  form.other_cancer = false
  form.drug_allergies = false
  form.glaucoma_or_eye_pressure_meds = false
  form.cardiac_conditions = false
  form.heart_attack = false
  form.arrhythmia = false
  form.stroke = false
  form.digestive_problems = false
  form.dry_mucous_membranes = false
  form.current_medications = false
  form.past_medications = false
  form.completed = true
end

# Vytvoř mikční deník
test_diary = VoidingDiary.find_or_create_by!(patient_id: test_patient.id) do |diary|
  diary.diary_start_date = Date.today
  diary.diary_duration_days = 1
  diary.bedtime_day_one = "22:00"
  diary.wake_up_time_day_one = "07:00"
  diary.completed = true
end

# Přidej záznamy do mikčního deníku (pouze pokud ještě neexistují)
if test_diary.voiding_records.count < 20
  10.times do |i|
    VoidingRecord.create!(
      voiding_diary: test_diary,
      recorded_at: 25.days.ago + (i * 2).hours,
      slept_before_and_after: false,
      urine_leakage: i.even?,
      urge_strength: [1, 2, 3].sample,
      urine_volume: 150 + (i * 10),
      urine_leakage_type: i.even? ? "stressful" : nil
    )

    VoidingRecord.create!(
      voiding_diary: test_diary,
      recorded_at: 25.days.ago + (i * 2 + 0.5).hours,
      urge_strength: [0, 1, 2].sample,
      fluid_intake: 100 + (i * 15),
      beverage_type: "clear_water"
    )
  end
end

# Vytvoř Initial Appointment
_appointment_initial = AppointmentInitial.find_or_create_by!(patient_id: test_patient.id) do |appointment|
  appointment.doctor = test_doctor
  appointment.assessment_date = 10.days.ago
  appointment.diagnosis = 'oab'
  appointment.oab_treatment_criteria_met = true
  appointment.initiate_pharmacological_treatment = true
  appointment.prescribed_medication = 'mirabegron'
  appointment.dosage = 50.0
  appointment.dosage_unit = 'mg'
end

# Vytvoř First Appointment s appointment_date a follow_up_date
first_appointment_date = 5.days.from_now
follow_up_date = first_appointment_date + 3.months

_appointment_first = AppointmentFirst.find_or_create_by!(patient_id: test_patient.id) do |appointment|
  appointment.doctor = test_doctor
  appointment.appointment_date = first_appointment_date
  appointment.follow_up_date = follow_up_date
  appointment.consent_signed = true
  appointment.meets_project_criteria = true
  appointment.clinical_assessment_completed = true
  appointment.stress_test_done = true
  appointment.stress_test_result = true
  appointment.uti_excluded = true
  appointment.bladder_discomfort_vas = 5
  appointment.diagnosis = 'oab'
  appointment.oab_treatment_criteria_met = true
  appointment.prescribed_medication = 'mirabegron'
  appointment.dosage = 50.0
  appointment.dosage_unit = 'mg'
end

# Callback v AppointmentFirst automaticky aktualizuje next_appointment na follow_up_date

# Vytvoř Second Appointment s appointment_date
second_appointment_date = follow_up_date + 2.days

_appointment_second = AppointmentSecond.find_or_create_by!(patient_id: test_patient.id) do |appointment|
  appointment.doctor = test_doctor
  appointment.attended_appointment = true
  appointment.appointment_date = second_appointment_date
  appointment.continuing_treatment = 'true'
  appointment.current_treatment = 'same_dose'
  appointment.prescribed_medication = 'mirabegron'
  appointment.dosage = 50.0
  appointment.dosage_unit = 'mg'
  appointment.visual_analog_scale = 3
end

# Callback v AppointmentSecond automaticky aktualizuje next_appointment na appointment_date

# Reload patient aby se načetly aktualizované data z callbacků
test_patient.reload

puts "✓ Testovací data vytvořena:"
puts "  - Doktor: doctor.test@example.com (heslo: test123)"
puts "  - Pacient: patient.test.appointments@example.com (heslo: test123)"
puts "  - První návštěva: #{first_appointment_date.strftime('%d.%m.%Y %H:%M')}"
puts "  - Kontrolní návštěva: #{second_appointment_date.strftime('%d.%m.%Y %H:%M')}"
puts "  - Patient.next_appointment (po callbacku): #{test_patient.next_appointment&.strftime('%d.%m.%Y %H:%M')}"
puts "  - ✓ Callback AppointmentSecond aktualizoval next_appointment automaticky!"

# ============================================================================
# TESTOVACÍ PACIENT 2: Pacient s vyplněnou pouze první návštěvou (bez druhé)
# ============================================================================

test_patient_2_user = User.find_or_create_by!(email: 'patient.test.first.only@example.com') do |user|
  user.password = 'test123'
  user.password_confirmation = 'test123'
  user.confirmed_at = Time.current
end

test_patient_2_user.add_role(Role::PATIENT) unless test_patient_2_user.has_role?(Role::PATIENT)

test_patient_2 = Patient.find_or_create_by!(user_id: test_patient_2_user.id) do |patient|
  patient.full_name = 'Jen PrvníNávštěva'
  patient.gender = 'male'
  patient.doctor = test_doctor
end

# Vytvoř dotazníky pro testovacího pacienta 2 (muž)
OabForm.find_or_create_by!(patient_id: test_patient_2.id) do |form|
  form.daytime_urination_frequency = 4
  form.unpleasant_urination_urge = 3
  form.sudden_urination_urge = 4
  form.occasional_leak = 2
  form.nighttime_urination = 4
  form.waking_up_to_urinate = 3
  form.uncontrollable_urge = 3
  form.leak_due_to_intense_urge = 2
  form.total_score = 25
  form.completed = true
  form.completion_timestamp = 35.days.ago
end

IciqForm.find_or_create_by!(patient_id: test_patient_2.id) do |form|
  form.leakage_frequency = 2
  form.leakage_assessment = 0
  form.leakage_severity = 5
  form.never_leaks = false
  form.leaks_before_reaching_toilet = true
  form.leaks_when_coughing_or_sneezing = false
  form.leaks_during_sleep = false
  form.leaks_during_physical_activity = true
  form.leaks_after_urinating_and_dressing = true
  form.leaks_for_unknown_reasons = false
  form.constant_leakage = false
  form.total_score = 7
  form.completed = true
  form.completion_timestamp = 34.days.ago
end

IpssForm.find_or_create_by!(patient_id: test_patient_2.id) do |form|
  form.incomplete_emptying = 1
  form.frequency = 1
  form.intermittent_urination = 0
  form.urgency = 1
  form.weak_stream = 0
  form.straining = 1
  form.nocturnal_urination = 1
  form.total_score = 5
  form.quality_of_life = 3
  form.completed = true
  form.completion_timestamp = 33.days.ago
end

AnamnesticForm.find_or_create_by!(patient_id: test_patient_2.id) do |form|
  form.completion_timestamp = 32.days.ago
  form.age = 58
  form.height = 178
  form.weight = 85
  form.on_oab_medication_last_3_months = false
  form.number_of_births = 0
  form.post_menopausal = false
  form.prolapse_diagnosed = false
  form.hysterectomy = false
  form.cesarean_section = 0
  form.surgery_for_benign_prostate_enlargement = false
  form.surgery_for_prostate_cancer = false
  form.surgery_for_bladder_tumor = false
  form.surgery_for_urethral_stricture = false
  form.surgery_for_urine_leakage = false
  form.other_surgery = false
  form.no_surgery = true
  form.recurrent_infections = false
  form.neurological_surgery_history = false
  form.hypertension = true
  form.hypothyroidism = false
  form.high_cholesterol = true
  form.diabetes = false
  form.back_problems = false
  form.depression = false
  form.other_psychiatric_conditions = false
  form.reduced_immunity = false
  form.headaches = false
  form.hip_osteoarthritis = false
  form.knee_osteoarthritis = false
  form.no_illness = false
  form.cancer_treatment_history = false
  form.cervical_cancer = false
  form.endometrial_cancer = false
  form.ovarian_cancer = false
  form.breast_cancer = false
  form.intestinal_cancer = false
  form.other_cancer = false
  form.drug_allergies = false
  form.glaucoma_or_eye_pressure_meds = false
  form.cardiac_conditions = false
  form.heart_attack = false
  form.arrhythmia = false
  form.stroke = false
  form.digestive_problems = false
  form.dry_mucous_membranes = false
  form.current_medications = true
  form.current_medications_details = "Léky na hypertenzi a cholesterol"
  form.past_medications = false
  form.completed = true
end

# Vytvoř mikční deník
test_diary_2 = VoidingDiary.find_or_create_by!(patient_id: test_patient_2.id) do |diary|
  diary.diary_start_date = Date.today
  diary.diary_duration_days = 1
  diary.bedtime_day_one = "23:00"
  diary.wake_up_time_day_one = "06:30"
  diary.completed = true
end

# Přidej záznamy do mikčního deníku (pouze pokud ještě neexistují)
if test_diary_2.voiding_records.count < 20
  10.times do |i|
    VoidingRecord.create!(
      voiding_diary: test_diary_2,
      recorded_at: 30.days.ago + (i * 2).hours,
      slept_before_and_after: false,
      urine_leakage: false,
      urge_strength: [1, 2, 3, 4].sample,
      urine_volume: 120 + (i * 15)
    )

    VoidingRecord.create!(
      voiding_diary: test_diary_2,
      recorded_at: 30.days.ago + (i * 2 + 0.5).hours,
      urge_strength: [0, 1, 2].sample,
      fluid_intake: 150 + (i * 10),
      beverage_type: ["clear_water", "hot_beverage", "sweet_drink"].sample
    )
  end
end

# Initial Appointment
AppointmentInitial.find_or_create_by!(patient_id: test_patient_2.id) do |appointment|
  appointment.doctor = test_doctor
  appointment.assessment_date = 20.days.ago
  appointment.diagnosis = 'oab'
  appointment.oab_treatment_criteria_met = true
  appointment.initiate_pharmacological_treatment = true
  appointment.prescribed_medication = 'mirabegron'
  appointment.dosage = 50.0
  appointment.dosage_unit = 'mg'
end

# First Appointment only
first_appt_date_2 = 3.days.from_now
follow_up_date_2 = first_appt_date_2 + 3.months

_appointment_first_2 = AppointmentFirst.find_or_create_by!(patient_id: test_patient_2.id) do |appointment|
  appointment.doctor = test_doctor
  appointment.appointment_date = first_appt_date_2
  appointment.follow_up_date = follow_up_date_2
  appointment.consent_signed = true
  appointment.meets_project_criteria = true
  appointment.clinical_assessment_completed = true
  appointment.stress_test_done = true
  appointment.stress_test_result = true
  appointment.uti_excluded = true
  appointment.bladder_discomfort_vas = 4
  appointment.diagnosis = 'oab'
  appointment.oab_treatment_criteria_met = true
  appointment.prescribed_medication = 'mirabegron'
  appointment.dosage = 50.0
  appointment.dosage_unit = 'mg'
end

# Reload patient aby se načetly aktualizované data z callbacku
test_patient_2.reload

puts "\n✓ Testovací pacient 2 vytvořen:"
puts "  - Email: patient.test.first.only@example.com (heslo: test123)"
puts "  - Jméno: Jen PrvníNávštěva"
puts "  - První návštěva: #{first_appt_date_2.strftime('%d.%m.%Y %H:%M')}"
puts "  - Plánovaná kontrolní návštěva: #{follow_up_date_2.strftime('%d.%m.%Y %H:%M')}"
puts "  - Patient.next_appointment: #{test_patient_2.next_appointment&.strftime('%d.%m.%Y %H:%M')}"

# ============================================================================
# TESTOVACÍ PACIENT 3: Pacient s vyplněnou pouze Initial Appointment
# ============================================================================

test_patient_3_user = User.find_or_create_by!(email: 'patient.test.initial.only@example.com') do |user|
  user.password = 'test123'
  user.password_confirmation = 'test123'
  user.confirmed_at = Time.current
end

test_patient_3_user.add_role(Role::PATIENT) unless test_patient_3_user.has_role?(Role::PATIENT)

test_patient_3 = Patient.find_or_create_by!(user_id: test_patient_3_user.id) do |patient|
  patient.full_name = 'Petra InicialníOnly'
  patient.gender = 'female'
  patient.doctor = test_doctor
end

# Vytvoř dotazníky pro testovacího pacienta 3 (žena)
OabForm.find_or_create_by!(patient_id: test_patient_3.id) do |form|
  form.daytime_urination_frequency = 5
  form.unpleasant_urination_urge = 4
  form.sudden_urination_urge = 5
  form.occasional_leak = 4
  form.nighttime_urination = 3
  form.waking_up_to_urinate = 4
  form.uncontrollable_urge = 5
  form.leak_due_to_intense_urge = 4
  form.total_score = 34
  form.completed = true
  form.completion_timestamp = 40.days.ago
end

IciqForm.find_or_create_by!(patient_id: test_patient_3.id) do |form|
  form.leakage_frequency = 4
  form.leakage_assessment = 0
  form.leakage_severity = 7
  form.never_leaks = false
  form.leaks_before_reaching_toilet = true
  form.leaks_when_coughing_or_sneezing = true
  form.leaks_during_sleep = true
  form.leaks_during_physical_activity = true
  form.leaks_after_urinating_and_dressing = true
  form.leaks_for_unknown_reasons = false
  form.constant_leakage = false
  form.total_score = 11
  form.completed = true
  form.completion_timestamp = 39.days.ago
end

AnamnesticForm.find_or_create_by!(patient_id: test_patient_3.id) do |form|
  form.completion_timestamp = 38.days.ago
  form.age = 52
  form.height = 168
  form.weight = 75
  form.on_oab_medication_last_3_months = false
  form.number_of_births = 3
  form.post_menopausal = true
  form.prolapse_diagnosed = false
  form.hysterectomy = false
  form.cesarean_section = 1
  form.surgery_for_benign_prostate_enlargement = false
  form.surgery_for_prostate_cancer = false
  form.surgery_for_bladder_tumor = false
  form.surgery_for_urethral_stricture = false
  form.surgery_for_urine_leakage = false
  form.other_surgery = false
  form.no_surgery = true
  form.recurrent_infections = false
  form.neurological_surgery_history = false
  form.hypertension = false
  form.hypothyroidism = true
  form.high_cholesterol = false
  form.diabetes = false
  form.back_problems = true
  form.depression = false
  form.other_psychiatric_conditions = false
  form.reduced_immunity = false
  form.headaches = true
  form.hip_osteoarthritis = false
  form.knee_osteoarthritis = false
  form.no_illness = false
  form.cancer_treatment_history = false
  form.cervical_cancer = false
  form.endometrial_cancer = false
  form.ovarian_cancer = false
  form.breast_cancer = false
  form.intestinal_cancer = false
  form.other_cancer = false
  form.drug_allergies = false
  form.glaucoma_or_eye_pressure_meds = false
  form.cardiac_conditions = false
  form.heart_attack = false
  form.arrhythmia = false
  form.stroke = false
  form.digestive_problems = false
  form.dry_mucous_membranes = false
  form.current_medications = true
  form.current_medications_details = "Léky na štítnou žlázu"
  form.past_medications = false
  form.completed = true
end

# Vytvoř mikční deník
test_diary_3 = VoidingDiary.find_or_create_by!(patient_id: test_patient_3.id) do |diary|
  diary.diary_start_date = Date.today
  diary.diary_duration_days = 1
  diary.bedtime_day_one = "22:30"
  diary.wake_up_time_day_one = "07:30"
  diary.completed = true
end

# Přidej záznamy do mikčního deníku (pouze pokud ještě neexistují)
if test_diary_3.voiding_records.count < 20
  10.times do |i|
    VoidingRecord.create!(
      voiding_diary: test_diary_3,
      recorded_at: 35.days.ago + (i * 2).hours,
      slept_before_and_after: false,
      urine_leakage: i.odd?,
      urge_strength: [2, 3, 4].sample,
      urine_volume: 100 + (i * 12),
      urine_leakage_type: i.odd? ? "urgent" : nil
    )

    VoidingRecord.create!(
      voiding_diary: test_diary_3,
      recorded_at: 35.days.ago + (i * 2 + 0.5).hours,
      urge_strength: [1, 2, 3].sample,
      fluid_intake: 120 + (i * 12),
      beverage_type: "clear_water"
    )
  end
end

# Pouze Initial Appointment
AppointmentInitial.find_or_create_by!(patient_id: test_patient_3.id) do |appointment|
  appointment.doctor = test_doctor
  appointment.assessment_date = 15.days.ago
  appointment.diagnosis = 'oab'
  appointment.oab_treatment_criteria_met = true
  appointment.initiate_pharmacological_treatment = true
  appointment.prescribed_medication = 'mirabegron'
  appointment.dosage = 50.0
  appointment.dosage_unit = 'mg'
end

puts "\n✓ Testovací pacient 3 vytvořen:"
puts "  - Email: patient.test.initial.only@example.com (heslo: test123)"
puts "  - Jméno: Petra InicialníOnly"
puts "  - Stav: Pouze vyplněná vzdálená diagnostika (Initial Appointment)"
