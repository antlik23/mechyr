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

  # ============================================================================
  # DALŠÍ TESTOVACÍ DOKTOŘI PRO STRÁNKOVÁNÍ A VYHLEDÁVÁNÍ
  # ============================================================================

  # 6. Urogynekolog - Brno
  doctor6_user = User.find_or_create_by!(email: 'doctor6@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Helena Malá'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor6_user.update!(confirmed_at: Time.current) if doctor6_user.confirmed_at.nil?
  doctor6_user.add_role(Role::DOCTOR) unless doctor6_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor6_user.id) do |doctor|
    doctor.full_name = 'MUDr. Helena Malá'
    doctor.contact_email = 'doctor6@example.com'
    doctor.contact_phone = '+420 541 123 456'
    doctor.workplace = 'Urogynekologická klinika Brno'
    doctor.city = 'Brno'
    doctor.postal_code = '602 00'
    doctor.street_and_number = 'Masarykova 25'
    doctor.full_capacity = false
    doctor.specialization = :urogynecologist
  end

  # 7. Urolog - Ostrava
  doctor7_user = User.find_or_create_by!(email: 'doctor7@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Tomáš Veselý'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor7_user.update!(confirmed_at: Time.current) if doctor7_user.confirmed_at.nil?
  doctor7_user.add_role(Role::DOCTOR) unless doctor7_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor7_user.id) do |doctor|
    doctor.full_name = 'MUDr. Tomáš Veselý'
    doctor.contact_email = 'doctor7@example.com'
    doctor.contact_phone = '+420 596 123 789'
    doctor.workplace = 'Urologické centrum Ostrava'
    doctor.city = 'Ostrava'
    doctor.postal_code = '702 00'
    doctor.street_and_number = 'Hlavní 88'
    doctor.full_capacity = false
    doctor.specialization = :urologist
  end

  # 8. Gynekolog - Liberec
  doctor8_user = User.find_or_create_by!(email: 'doctor8@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Petra Černá'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor8_user.update!(confirmed_at: Time.current) if doctor8_user.confirmed_at.nil?
  doctor8_user.add_role(Role::DOCTOR) unless doctor8_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor8_user.id) do |doctor|
    doctor.full_name = 'MUDr. Petra Černá'
    doctor.contact_email = 'doctor8@example.com'
    doctor.contact_phone = '+420 485 111 222'
    doctor.workplace = 'Gynekologická ordinace Liberec'
    doctor.city = 'Liberec'
    doctor.postal_code = '460 01'
    doctor.street_and_number = 'Česká 12'
    doctor.full_capacity = false
    doctor.specialization = :gynecologist
  end

  # 9. Praktický lékař - Hradec Králové
  doctor9_user = User.find_or_create_by!(email: 'doctor9@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Jan Bílý'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor9_user.update!(confirmed_at: Time.current) if doctor9_user.confirmed_at.nil?
  doctor9_user.add_role(Role::DOCTOR) unless doctor9_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor9_user.id) do |doctor|
    doctor.full_name = 'MUDr. Jan Bílý'
    doctor.contact_email = 'doctor9@example.com'
    doctor.contact_phone = '+420 495 333 444'
    doctor.workplace = 'Poliklinika Hradec Králové'
    doctor.city = 'Hradec Králové'
    doctor.postal_code = '500 02'
    doctor.street_and_number = 'Riegrova 45'
    doctor.full_capacity = false
    doctor.specialization = :general
  end

  # 10. Urogynekolog - České Budějovice
  doctor10_user = User.find_or_create_by!(email: 'doctor10@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Marcela Nová'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor10_user.update!(confirmed_at: Time.current) if doctor10_user.confirmed_at.nil?
  doctor10_user.add_role(Role::DOCTOR) unless doctor10_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor10_user.id) do |doctor|
    doctor.full_name = 'MUDr. Marcela Nová'
    doctor.contact_email = 'doctor10@example.com'
    doctor.contact_phone = '+420 387 555 666'
    doctor.workplace = 'Urogynekologie České Budějovice'
    doctor.city = 'České Budějovice'
    doctor.postal_code = '370 01'
    doctor.street_and_number = 'Pražská 78'
    doctor.full_capacity = false
    doctor.specialization = :urogynecologist
  end

  # 11. Urolog - Olomouc
  doctor11_user = User.find_or_create_by!(email: 'doctor11@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Pavel Zelený'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor11_user.update!(confirmed_at: Time.current) if doctor11_user.confirmed_at.nil?
  doctor11_user.add_role(Role::DOCTOR) unless doctor11_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor11_user.id) do |doctor|
    doctor.full_name = 'MUDr. Pavel Zelený'
    doctor.contact_email = 'doctor11@example.com'
    doctor.contact_phone = '+420 585 777 888'
    doctor.workplace = 'Urologická ambulance Olomouc'
    doctor.city = 'Olomouc'
    doctor.postal_code = '779 00'
    doctor.street_and_number = 'Universitní 33'
    doctor.full_capacity = false
    doctor.specialization = :urologist
  end

  # 12. Gynekolog - Zlín
  doctor12_user = User.find_or_create_by!(email: 'doctor12@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Eva Růžová'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor12_user.update!(confirmed_at: Time.current) if doctor12_user.confirmed_at.nil?
  doctor12_user.add_role(Role::DOCTOR) unless doctor12_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor12_user.id) do |doctor|
    doctor.full_name = 'MUDr. Eva Růžová'
    doctor.contact_email = 'doctor12@example.com'
    doctor.contact_phone = '+420 577 999 111'
    doctor.workplace = 'Gynekologie Zlín'
    doctor.city = 'Zlín'
    doctor.postal_code = '760 01'
    doctor.street_and_number = 'Nádražní 56'
    doctor.full_capacity = false
    doctor.specialization = :gynecologist
  end

  # 13. Praktický lékař - Pardubice
  doctor13_user = User.find_or_create_by!(email: 'doctor13@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Miroslav Modrý'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor13_user.update!(confirmed_at: Time.current) if doctor13_user.confirmed_at.nil?
  doctor13_user.add_role(Role::DOCTOR) unless doctor13_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor13_user.id) do |doctor|
    doctor.full_name = 'MUDr. Miroslav Modrý'
    doctor.contact_email = 'doctor13@example.com'
    doctor.contact_phone = '+420 466 222 333'
    doctor.workplace = 'Zdravotní centrum Pardubice'
    doctor.city = 'Pardubice'
    doctor.postal_code = '530 02'
    doctor.street_and_number = 'Sukova 89'
    doctor.full_capacity = false
    doctor.specialization = :general
  end

  # 14. Urogynekolog - Jihlava
  doctor14_user = User.find_or_create_by!(email: 'doctor14@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Lucie Šedá'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor14_user.update!(confirmed_at: Time.current) if doctor14_user.confirmed_at.nil?
  doctor14_user.add_role(Role::DOCTOR) unless doctor14_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor14_user.id) do |doctor|
    doctor.full_name = 'MUDr. Lucie Šedá'
    doctor.contact_email = 'doctor14@example.com'
    doctor.contact_phone = '+420 567 444 555'
    doctor.workplace = 'Urogynekologická poradna Jihlava'
    doctor.city = 'Jihlava'
    doctor.postal_code = '586 01'
    doctor.street_and_number = 'Brněnská 67'
    doctor.full_capacity = false
    doctor.specialization = :urogynecologist
  end

  # 15. Urolog - Karlovy Vary
  doctor15_user = User.find_or_create_by!(email: 'doctor15@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Robert Hnědý'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor15_user.update!(confirmed_at: Time.current) if doctor15_user.confirmed_at.nil?
  doctor15_user.add_role(Role::DOCTOR) unless doctor15_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor15_user.id) do |doctor|
    doctor.full_name = 'MUDr. Robert Hnědý'
    doctor.contact_email = 'doctor15@example.com'
    doctor.contact_phone = '+420 353 666 777'
    doctor.workplace = 'Urologická klinika Karlovy Vary'
    doctor.city = 'Karlovy Vary'
    doctor.postal_code = '360 01'
    doctor.street_and_number = 'Lázeňská 23'
    doctor.full_capacity = false
    doctor.specialization = :urologist
  end

  # 16. Gynekolog - Ústí nad Labem
  doctor16_user = User.find_or_create_by!(email: 'doctor16@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Alena Fialová'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor16_user.update!(confirmed_at: Time.current) if doctor16_user.confirmed_at.nil?
  doctor16_user.add_role(Role::DOCTOR) unless doctor16_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor16_user.id) do |doctor|
    doctor.full_name = 'MUDr. Alena Fialová'
    doctor.contact_email = 'doctor16@example.com'
    doctor.contact_phone = '+420 475 888 999'
    doctor.workplace = 'Gynekologická ordinace Ústí'
    doctor.city = 'Ústí nad Labem'
    doctor.postal_code = '400 01'
    doctor.street_and_number = 'Lidická 44'
    doctor.full_capacity = false
    doctor.specialization = :gynecologist
  end

  # 17. Urogynekolog - Havířov
  doctor17_user = User.find_or_create_by!(email: 'doctor17@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Daniela Stříbrná'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor17_user.update!(confirmed_at: Time.current) if doctor17_user.confirmed_at.nil?
  doctor17_user.add_role(Role::DOCTOR) unless doctor17_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor17_user.id) do |doctor|
    doctor.full_name = 'MUDr. Daniela Stříbrná'
    doctor.contact_email = 'doctor17@example.com'
    doctor.contact_phone = '+420 596 111 333'
    doctor.workplace = 'Poliklinika Havířov'
    doctor.city = 'Havířov'
    doctor.postal_code = '736 01'
    doctor.street_and_number = 'Svornosti 15'
    doctor.full_capacity = false
    doctor.specialization = :urogynecologist
  end

  # 18. Praktický lékař - Most
  doctor18_user = User.find_or_create_by!(email: 'doctor18@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Jiří Zlatý'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor18_user.update!(confirmed_at: Time.current) if doctor18_user.confirmed_at.nil?
  doctor18_user.add_role(Role::DOCTOR) unless doctor18_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor18_user.id) do |doctor|
    doctor.full_name = 'MUDr. Jiří Zlatý'
    doctor.contact_email = 'doctor18@example.com'
    doctor.contact_phone = '+420 476 222 555'
    doctor.workplace = 'Zdravotní středisko Most'
    doctor.city = 'Most'
    doctor.postal_code = '434 01'
    doctor.street_and_number = 'Budovatelů 99'
    doctor.full_capacity = false
    doctor.specialization = :general
  end

  # 19. Urolog - Kladno
  doctor19_user = User.find_or_create_by!(email: 'doctor19@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Michal Oranžový'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor19_user.update!(confirmed_at: Time.current) if doctor19_user.confirmed_at.nil?
  doctor19_user.add_role(Role::DOCTOR) unless doctor19_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor19_user.id) do |doctor|
    doctor.full_name = 'MUDr. Michal Oranžový'
    doctor.contact_email = 'doctor19@example.com'
    doctor.contact_phone = '+420 312 333 666'
    doctor.workplace = 'Urologická ambulance Kladno'
    doctor.city = 'Kladno'
    doctor.postal_code = '272 01'
    doctor.street_and_number = 'Náměstí Svobody 8'
    doctor.full_capacity = false
    doctor.specialization = :urologist
  end

  # 20. Gynekolog - Mladá Boleslav (s plnou kapacitou)
  doctor20_user = User.find_or_create_by!(email: 'doctor20@example.com') do |user|
    user.first_name = 'MUDr.'
    user.last_name = 'Tereza Bronzová'
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end
  doctor20_user.update!(confirmed_at: Time.current) if doctor20_user.confirmed_at.nil?
  doctor20_user.add_role(Role::DOCTOR) unless doctor20_user.has_role?(Role::DOCTOR)

  Doctor.find_or_create_by!(user_id: doctor20_user.id) do |doctor|
    doctor.full_name = 'MUDr. Tereza Bronzová'
    doctor.contact_email = 'doctor20@example.com'
    doctor.contact_phone = '+420 326 777 888'
    doctor.workplace = 'Gynekologie Mladá Boleslav'
    doctor.city = 'Mladá Boleslav'
    doctor.postal_code = '293 01'
    doctor.street_and_number = 'Jičínská 28'
    doctor.full_capacity = true
    doctor.specialization = :gynecologist
  end

  puts "\n✓ Testovací doktoři vytvořeni (celkem 20):"
  puts '  1. Urogynekolog: doctor.test@example.com (heslo: test123) - pro všechny pacienty'
  puts '  2. Urolog: urologist.test@example.com (heslo: test123) - pouze muži'
  puts '  3. Gynekolog: gynecologist.test@example.com (heslo: test123) - pouze ženy'
  puts '  4. Praktický lékař: general.test@example.com (heslo: test123) - pro všechny'
  puts '  5. Urolog s plnou kapacitou: full.capacity@example.com - NEVIDITELNÝ pro nové pacienty'
  puts '  6-20. Další doktoři pro testování stránkování a vyhledávání (doctor6@example.com - doctor20@example.com)'

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

  # ============================================================================
  # PACIENTI S HOTOVÝMI FORMULÁŘI A BEZ DEMÍKŮ
  # ============================================================================

  # 6. PACIENT S HOTOVÝMI FORMULÁŘI - ŽENA
  complete_forms_female_user = User.find_or_create_by!(email: 'complete.forms.female@example.com') do |user|
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end

  complete_forms_female_user.update!(confirmed_at: Time.current) if complete_forms_female_user.confirmed_at.nil?
  complete_forms_female_user.add_role(Role::PATIENT) unless complete_forms_female_user.has_role?(Role::PATIENT)

  complete_forms_female = Patient.find_or_create_by!(user_id: complete_forms_female_user.id) do |patient|
    patient.full_name = 'Anna Hotová'
    patient.gender = 'female'
    patient.doctor_id = nil
    patient.approved = nil
    patient.agreed_to_share_info = nil
  end

  # Vytvoř dotazníky pro pacienta s hotovými formuláři - žena
  OabForm.find_or_create_by!(patient_id: complete_forms_female.id) do |form|
    form.daytime_urination_frequency = 4
    form.unpleasant_urination_urge = 5
    form.sudden_urination_urge = 5
    form.occasional_leak = 4
    form.nighttime_urination = 4
    form.waking_up_to_urinate = 5
    form.uncontrollable_urge = 4
    form.leak_due_to_intense_urge = 4
    form.total_score = 35
    form.completed = true
    form.completion_timestamp = 20.days.ago
  end

  IciqForm.find_or_create_by!(patient_id: complete_forms_female.id) do |form|
    form.leakage_frequency = 4
    form.leakage_assessment = 0
    form.leakage_severity = 8
    form.never_leaks = false
    form.leaks_before_reaching_toilet = true
    form.leaks_when_coughing_or_sneezing = true
    form.leaks_during_sleep = false
    form.leaks_during_physical_activity = true
    form.leaks_after_urinating_and_dressing = true
    form.leaks_for_unknown_reasons = false
    form.constant_leakage = false
    form.total_score = 12
    form.completed = true
    form.completion_timestamp = 19.days.ago
  end

  AnamnesticForm.find_or_create_by!(patient_id: complete_forms_female.id) do |form|
    form.completion_timestamp = 18.days.ago
    form.age = 48
    form.height = 172
    form.weight = 68
    form.on_oab_medication_last_3_months = false
    form.number_of_births = 2
    form.post_menopausal = false
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

  puts "\n✓ Pacient s hotovými formuláři (žena) vytvořen:"
  puts '  - Email: complete.forms.female@example.com (heslo: test123)'
  puts '  - Jméno: Anna Hotová'
  puts '  - Stav: Všechny formuláře vyplněné, žádný mikční deník, žádný doktor'

  # 7. PACIENT S HOTOVÝMI FORMULÁŘI - MUŽ
  complete_forms_male_user = User.find_or_create_by!(email: 'complete.forms.male@example.com') do |user|
    user.password = 'test123'
    user.password_confirmation = 'test123'
    user.confirmed_at = Time.current
  end

  complete_forms_male_user.update!(confirmed_at: Time.current) if complete_forms_male_user.confirmed_at.nil?
  complete_forms_male_user.add_role(Role::PATIENT) unless complete_forms_male_user.has_role?(Role::PATIENT)

  complete_forms_male = Patient.find_or_create_by!(user_id: complete_forms_male_user.id) do |patient|
    patient.full_name = 'Pavel Kompletní'
    patient.gender = 'male'
    patient.doctor_id = nil
    patient.approved = nil
    patient.agreed_to_share_info = nil
  end

  # Vytvoř dotazníky pro pacienta s hotovými formuláři - muž
  OabForm.find_or_create_by!(patient_id: complete_forms_male.id) do |form|
    form.daytime_urination_frequency = 3
    form.unpleasant_urination_urge = 4
    form.sudden_urination_urge = 4
    form.occasional_leak = 2
    form.nighttime_urination = 5
    form.waking_up_to_urinate = 4
    form.uncontrollable_urge = 3
    form.leak_due_to_intense_urge = 2
    form.total_score = 27
    form.completed = true
    form.completion_timestamp = 22.days.ago
  end

  IciqForm.find_or_create_by!(patient_id: complete_forms_male.id) do |form|
    form.leakage_frequency = 3
    form.leakage_assessment = 0
    form.leakage_severity = 6
    form.never_leaks = false
    form.leaks_before_reaching_toilet = true
    form.leaks_when_coughing_or_sneezing = false
    form.leaks_during_sleep = false
    form.leaks_during_physical_activity = false
    form.leaks_after_urinating_and_dressing = true
    form.leaks_for_unknown_reasons = false
    form.constant_leakage = false
    form.total_score = 9
    form.completed = true
    form.completion_timestamp = 21.days.ago
  end

  IpssForm.find_or_create_by!(patient_id: complete_forms_male.id) do |form|
    form.incomplete_emptying = 2
    form.frequency = 2
    form.intermittent_urination = 1
    form.urgency = 2
    form.weak_stream = 1
    form.straining = 1
    form.nocturnal_urination = 2
    form.total_score = 11
    form.quality_of_life = 4
    form.completed = true
    form.completion_timestamp = 20.days.ago
  end

  AnamnesticForm.find_or_create_by!(patient_id: complete_forms_male.id) do |form|
    form.completion_timestamp = 19.days.ago
    form.age = 62
    form.height = 180
    form.weight = 88
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
    form.diabetes = true
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
    form.current_medications_details = 'Léky na hypertenzi, cholesterol a diabetes'
    form.past_medications = false
    form.completed = true
  end

  puts "\n✓ Pacient s hotovými formuláři (muž) vytvořen:"
  puts '  - Email: complete.forms.male@example.com (heslo: test123)'
  puts '  - Jméno: Pavel Kompletní'
  puts '  - Stav: Všechny formuláře vyplněné (včetně IPSS), žádný mikční deník, žádný doktor'
end
