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
  Role.find_or_create_by!(name: 'patient')
  10.times do |i|

    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    full_name = "#{first_name} #{last_name}"
    email = "patient#{i+1}@example.com"
    password = "test123"

    User.find_or_create_by!(email: email) do |user|
      user.password = password
      user.password_confirmation = password
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

        diary_start_date: Faker::Time.between(from: 1.year.ago, to: Time.now),
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

        diary_start_date: Faker::Time.between(from: 1.year.ago, to: Time.now),
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
end


User.find_or_create_by!(first_name: 'John', last_name: 'Doe', email: 'admin@test.com', role: :admin) do |user|
  user.password = 'test123'
  user.password_confirmation = 'test123'
  user.add_role(:admin)
end
