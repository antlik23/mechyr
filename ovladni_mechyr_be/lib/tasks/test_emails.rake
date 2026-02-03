# frozen_string_literal: true

namespace :test do
  desc 'Send test emails to Letter Opener'
  task emails: :environment do
    puts '📧 Odesílám testovací emaily...'
    puts ''

    # Najít testovací uživatele, doktora a pacienta
    doctor = Doctor.joins(:user).find_by(users: { email: 'doctor.test@example.com' })
    patient = Patient.joins(:user).find_by(users: { email: 'patient.test.appointments@example.com' })
    user = patient&.user

    unless doctor && patient && user
      puts '❌ Testovací data nebyla nalezena. Spusť: rails db:seed'
      exit 1
    end

    # 1. Welcome email
    puts '1️⃣  Odesílám Welcome Email...'
    UserMailer.welcome_email(user).deliver_now
    puts "   ✅ Odesláno na: #{user.email}"
    puts ''

    # 2. Request assignment email
    puts '2️⃣  Odesílám Request Assignment Email...'
    UserMailer.request_assignment_email(doctor, patient, 'Prosím o přiřazení k doktorovi.').deliver_now
    puts "   ✅ Odesláno na: #{doctor.contact_email || doctor.user.email}"
    puts ''

    # 3. Approve email
    puts '3️⃣  Odesílám Approve Email...'
    UserMailer.approve_email(doctor, patient).deliver_now
    puts "   ✅ Odesláno na: #{patient.user.email}"
    puts ''

    # 4. Reject email
    puts '4️⃣  Odesílám Reject Email...'
    UserMailer.reject_email(doctor, patient).deliver_now
    puts "   ✅ Odesláno na: #{patient.user.email}"
    puts ''

    # Najít appointment_first pro další testy
    appointment_first = AppointmentFirst.find_by(patient:)
    if appointment_first
      # 5. First appointment scheduled
      puts '5️⃣  Odesílám First Appointment Scheduled Email...'
      UserMailer.first_appointment_scheduled_email(doctor, patient, appointment_first).deliver_now
      puts "   ✅ Odesláno na: #{patient.user.email}"
      puts ''

      # 6. First appointment updated
      puts '6️⃣  Odesílám First Appointment Updated Email...'
      old_date = appointment_first.appointment_date - 7.days
      UserMailer.first_appointment_updated_email(doctor, patient, appointment_first, old_date).deliver_now
      puts "   ✅ Odesláno na: #{patient.user.email}"
      puts ''
    else
      puts '⚠️  AppointmentFirst nenalezen - přeskakuji emaily 5 a 6'
      puts ''
    end

    # Najít appointment_second pro další testy
    appointment_second = AppointmentSecond.find_by(patient:)
    if appointment_second
      # 7. Second appointment scheduled
      puts '7️⃣  Odesílám Second Appointment Scheduled Email...'
      UserMailer.second_appointment_scheduled_email(doctor, patient, appointment_second).deliver_now
      puts "   ✅ Odesláno na: #{patient.user.email}"
      puts ''

      # 8. Second appointment updated
      puts '8️⃣  Odesílám Second Appointment Updated Email...'
      old_date = appointment_second.appointment_date - 7.days
      UserMailer.second_appointment_updated_email(doctor, patient, appointment_second, old_date).deliver_now
      puts "   ✅ Odesláno na: #{patient.user.email}"
      puts ''
    else
      puts '⚠️  AppointmentSecond nenalezen - přeskakuji emaily 7 a 8'
      puts ''
    end

    puts '✨ Všechny testovací emaily byly odeslány!'
    puts ''
    puts '🌐 Zobraz je na: http://localhost:3000/letter_opener'
    puts ''
  end

  desc 'Send single test email'
  task :email, [:type] => :environment do |_t, args|
    type = args[:type] || 'welcome'

    doctor = Doctor.joins(:user).find_by(users: { email: 'doctor.test@example.com' })
    patient = Patient.joins(:user).find_by(users: { email: 'patient.test.appointments@example.com' })
    user = patient&.user

    unless doctor && patient && user
      puts '❌ Testovací data nebyla nalezena. Spusť: rails db:seed'
      exit 1
    end

    case type
    when 'welcome'
      puts '📧 Odesílám Welcome Email...'
      UserMailer.welcome_email(user).deliver_now
    when 'request'
      puts '📧 Odesílám Request Assignment Email...'
      UserMailer.request_assignment_email(doctor, patient, 'Testovací zpráva').deliver_now
    when 'approve'
      puts '📧 Odesílám Approve Email...'
      UserMailer.approve_email(doctor, patient).deliver_now
    when 'reject'
      puts '📧 Odesílám Reject Email...'
      UserMailer.reject_email(doctor, patient).deliver_now
    else
      puts "❌ Neznámý typ emailu: #{type}"
      puts 'Dostupné typy: welcome, request, approve, reject'
      exit 1
    end

    puts '✅ Email odeslán!'
    puts '🌐 Zobraz ho na: http://localhost:3000/letter_opener'
  end
end
