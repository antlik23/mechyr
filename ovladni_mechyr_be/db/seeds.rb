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
  # TESTOVACÍ DOKTOŘI S RŮZNÝMI SPECIALIZACEMI
  # ============================================================================

  # 1. UROGYNEKOLOG - může léčit všechny pacienty (muže i ženy)
  test_doctor_user = User.find_or_create_by!(email: 'doctor.test@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Testovací Urogynekolog'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end

  test_doctor_user.update!(confirmed_at: Time.current) if test_doctor_user.confirmed_at.nil?
  test_doctor_user.add_role(Role::DOCTOR) unless test_doctor_user.has_role?(Role::DOCTOR)

  test_doctor = Doctor.find_or_create_by!(user_id: test_doctor_user.id) do |doctor|
    doctor.full_name = 'MUDr. Testovací Urogynekolog'
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
  if test_doctor.workplace.nil? || test_doctor.full_name != 'MUDr. Testovací Urogynekolog'
    test_doctor.update!(
      full_name: 'MUDr. Testovací Urogynekolog',
      workplace: 'Testovací urologická klinika',
      city: 'Praha',
      postal_code: '110 00',
      street_and_number: 'Testovací 123',
      full_capacity: false,
      specialization: :urogynecologist
    )
  end

  # 2. UROLOG - pouze pro muže (male, with_prostate)
  urologist_user = User.find_or_create_by!(email: 'urologist.test@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Novák Urolog'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end

  urologist_user.update!(confirmed_at: Time.current) if urologist_user.confirmed_at.nil?
  urologist_user.add_role(Role::DOCTOR) unless urologist_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: urologist_user.id) do |doctor|
    doctor.full_name = 'MUDr. Karel Novák'
    doctor.contact_email = 'urologist.test@example.com'
    doctor.contact_phone = '+420 234 567 890'
    doctor.workplace = 'Urologická klinika Praha'
    doctor.city = 'Praha'
    doctor.postal_code = '120 00'
    doctor.street_and_number = 'Urologická 45'
    doctor.full_capacity = false
    doctor.specialization = :urologist
  end

  # 3. GYNEKOLOG - pouze pro ženy (female, without_prostate)
  gynecologist_user = User.find_or_create_by!(email: 'gynecologist.test@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Nováková Gynekolog'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end

  gynecologist_user.update!(confirmed_at: Time.current) if gynecologist_user.confirmed_at.nil?
  gynecologist_user.add_role(Role::DOCTOR) unless gynecologist_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: gynecologist_user.id) do |doctor|
    doctor.full_name = 'MUDr. Jana Nováková'
    doctor.contact_email = 'gynecologist.test@example.com'
    doctor.contact_phone = '+420 345 678 901'
    doctor.workplace = 'Gynekologická klinika Brno'
    doctor.city = 'Brno'
    doctor.postal_code = '602 00'
    doctor.street_and_number = 'Gynekologická 12'
    doctor.full_capacity = false
    doctor.specialization = :gynecologist
  end

  # 4. VŠEOBECNÝ LÉKAŘ - může léčit všechny pacienty
  general_user = User.find_or_create_by!(email: 'general.test@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Svoboda Praktik'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end

  general_user.update!(confirmed_at: Time.current) if general_user.confirmed_at.nil?
  general_user.add_role(Role::DOCTOR) unless general_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: general_user.id) do |doctor|
    doctor.full_name = 'MUDr. Petr Svoboda'
    doctor.contact_email = 'general.test@example.com'
    doctor.contact_phone = '+420 456 789 012'
    doctor.workplace = 'Praktická ordinace Ostrava'
    doctor.city = 'Ostrava'
    doctor.postal_code = '702 00'
    doctor.street_and_number = 'Hlavní 89'
    doctor.full_capacity = false
    doctor.specialization = :general
  end

  # 5. UROLOG S PLNOU KAPACITOU - neměl by být viditelný pro nové pacienty
  full_capacity_user = User.find_or_create_by!(email: 'full.capacity@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Dvořák Plný'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end

  full_capacity_user.update!(confirmed_at: Time.current) if full_capacity_user.confirmed_at.nil?
  full_capacity_user.add_role(Role::DOCTOR) unless full_capacity_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: full_capacity_user.id) do |doctor|
    doctor.full_name = 'MUDr. Martin Dvořák'
    doctor.contact_email = 'full.capacity@example.com'
    doctor.contact_phone = '+420 567 890 123'
    doctor.workplace = 'Urologická klinika Plzeň'
    doctor.city = 'Plzeň'
    doctor.postal_code = '301 00'
    doctor.street_and_number = 'Plná 1'
    doctor.full_capacity = true
    doctor.specialization = :urologist
  end

  puts "\n✓ Testovací doktoři vytvořeni:"
  puts '  1. Urogynekolog: doctor.test@example.com (heslo: test123) - pro všechny pacienty'
  puts '  2. Urolog: urologist.test@example.com (heslo: test123) - pouze muži'
  puts '  3. Gynekolog: gynecologist.test@example.com (heslo: test123) - pouze ženy'
  puts '  4. Praktický lékař: general.test@example.com (heslo: test123) - pro všechny'
  puts '  5. Urolog s plnou kapacitou: full.capacity@example.com - NEVIDITELNÝ pro nové pacienty'

  # ============================================================================
  # TESTOVACÍ DATA PRO ÚKOL 1: Datum návštěvy pacienta
  # ============================================================================

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
    patient.approved = true
    patient.agreed_to_share_info = true
  end

  # Update existing patient if not approved
  test_patient.update!(approved: true, agreed_to_share_info: true) unless test_patient.approved

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
    diary.bedtime_day_one = '22:00'
    diary.wake_up_time_day_one = '07:00'
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
        urine_leakage_type: i.even? ? 'stressful' : nil
      )

      VoidingRecord.create!(
        voiding_diary: test_diary,
        recorded_at: 25.days.ago + ((i * 2) + 0.5).hours,
        urge_strength: [0, 1, 2].sample,
        fluid_intake: 100 + (i * 15),
        beverage_type: 'clear_water'
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

  puts '✓ Testovací data vytvořena:'
  puts '  - Doktor: doctor.test@example.com (heslo: test123)'
  puts '  - Pacient: patient.test.appointments@example.com (heslo: test123)'
  puts "  - První návštěva: #{first_appointment_date.strftime('%d.%m.%Y %H:%M')}"
  puts "  - Kontrolní návštěva: #{second_appointment_date.strftime('%d.%m.%Y %H:%M')}"
  puts "  - Patient.next_appointment (po callbacku): #{test_patient.next_appointment&.strftime('%d.%m.%Y %H:%M')}"
  puts '  - ✓ Callback AppointmentSecond aktualizoval next_appointment automaticky!'

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
    patient.approved = true
    patient.agreed_to_share_info = true
  end

  # Update existing patient if not approved
  test_patient_2.update!(approved: true, agreed_to_share_info: true) unless test_patient_2.approved

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
    form.current_medications_details = 'Léky na hypertenzi a cholesterol'
    form.past_medications = false
    form.completed = true
  end

  # Vytvoř mikční deník
  test_diary_2 = VoidingDiary.find_or_create_by!(patient_id: test_patient_2.id) do |diary|
    diary.diary_start_date = Date.today
    diary.diary_duration_days = 1
    diary.bedtime_day_one = '23:00'
    diary.wake_up_time_day_one = '06:30'
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
        recorded_at: 30.days.ago + ((i * 2) + 0.5).hours,
        urge_strength: [0, 1, 2].sample,
        fluid_intake: 150 + (i * 10),
        beverage_type: ['clear_water', 'hot_beverage', 'sweet_drink'].sample
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
  puts '  - Email: patient.test.first.only@example.com (heslo: test123)'
  puts '  - Jméno: Jen PrvníNávštěva'
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
    patient.approved = true
    patient.agreed_to_share_info = true
  end

  # Update existing patient if not approved
  test_patient_3.update!(approved: true, agreed_to_share_info: true) unless test_patient_3.approved

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
    form.current_medications_details = 'Léky na štítnou žlázu'
    form.past_medications = false
    form.completed = true
  end

  # Vytvoř mikční deník
  test_diary_3 = VoidingDiary.find_or_create_by!(patient_id: test_patient_3.id) do |diary|
    diary.diary_start_date = Date.today
    diary.diary_duration_days = 1
    diary.bedtime_day_one = '22:30'
    diary.wake_up_time_day_one = '07:30'
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
        urine_leakage_type: i.odd? ? 'urgent' : nil
      )

      VoidingRecord.create!(
        voiding_diary: test_diary_3,
        recorded_at: 35.days.ago + ((i * 2) + 0.5).hours,
        urge_strength: [1, 2, 3].sample,
        fluid_intake: 120 + (i * 12),
        beverage_type: 'clear_water'
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
  puts '  - Email: patient.test.initial.only@example.com (heslo: test123)'
  puts '  - Jméno: Petra InicialníOnly'
  puts '  - Stav: Pouze vyplněná vzdálená diagnostika (Initial Appointment)'

  # ============================================================================
  # TESTOVACÍ PACIENTI BEZ PŘIŘAZENÉHO DOKTORA - PRO TESTOVÁNÍ VÝBĚRU LÉKAŘE
  # ============================================================================

  # 4. PACIENT MUŽ BEZ DOKTORA
  male_no_doctor_user = User.find_or_create_by!(email: 'male.nodoc@example.com') do |user|
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end

  male_no_doctor_user.update!(confirmed_at: Time.current) if male_no_doctor_user.confirmed_at.nil?
  male_no_doctor_user.add_role(Role::PATIENT) unless male_no_doctor_user.has_role?(Role::PATIENT)

  Patient.find_or_create_by!(user_id: male_no_doctor_user.id) do |patient|
    patient.full_name = 'Karel BezDoktora'
    patient.gender = 'male'
    patient.doctor_id = nil
    patient.approved = nil
    patient.agreed_to_share_info = nil
  end

  # 5. PACIENT ŽENA BEZ DOKTORA
  female_no_doctor_user = User.find_or_create_by!(email: 'female.nodoc@example.com') do |user|
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end

  female_no_doctor_user.update!(confirmed_at: Time.current) if female_no_doctor_user.confirmed_at.nil?
  female_no_doctor_user.add_role(Role::PATIENT) unless female_no_doctor_user.has_role?(Role::PATIENT)

  Patient.find_or_create_by!(user_id: female_no_doctor_user.id) do |patient|
    patient.full_name = 'Marie BezDoktorky'
    patient.gender = 'female'
    patient.doctor_id = nil
    patient.approved = nil
    patient.agreed_to_share_info = nil
  end

  puts "\n✓ Testovací pacienti bez doktora vytvořeni:"
  puts '  - Muž: male.nodoc@example.com (heslo: test123) - uvidí: Urogynekolog, Urolog, Praktický lékař'
  puts '  - Žena: female.nodoc@example.com (heslo: test123) - uvidí: Urogynekolog, Gynekolog, Praktický lékař'
  puts '  - Oba si mohou vybrat lékaře ze seznamu dostupných lékařů'
end
