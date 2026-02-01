# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: I18n.t('devise.mailer.registrations.subject'))
  end

  def request_assignment_email(doctor, patient, custom_message)
    @doctor = doctor
    @patient = patient
    @custom_message = custom_message
    @user_url = "#{Rails.application.credentials[:fe_url]}/patients/approved/#{patient.id}"

    email = doctor.contact_email
    email = doctor.user.email if email.blank?

    mail(to: email, subject: I18n.t('mailer.assignment.request.subject'))
  end

  def approve_email(doctor, patient)
    @doctor_name = doctor.full_name
    @next_appointment = patient.next_appointment
    @user_url = "#{Rails.application.credentials[:fe_url]}/doctors/#{doctor.id}"

    mail(to: patient.user.email, subject: I18n.t('mailer.assignment.approve.subject'))
  end

  def reject_email(doctor, patient)
    @doctor_name = doctor.full_name
    @doctors_url = "#{Rails.application.credentials[:fe_url]}/doctors"

    mail(to: patient.user.email, subject: I18n.t('mailer.assignment.reject.subject'))
  end

  # Úkol 11: Email notifikace pro stanovení termínu první návštěvy
  def first_appointment_scheduled_email(doctor, patient, appointment_first)
    @doctor_name = doctor.full_name
    @patient_name = "#{patient.first_name} #{patient.last_name}"
    @appointment_date = appointment_first.appointment_date
    @follow_up_date = appointment_first.follow_up_date
    @doctor_contact = doctor.contact_email || doctor.user.email
    @doctor_phone = doctor.contact_phone

    mail(to: patient.user.email, subject: 'Termín první návštěvy byl stanoven')
  end

  # Úkol 11: Email notifikace pro změnu termínu první návštěvy
  def first_appointment_updated_email(doctor, patient, appointment_first, old_date)
    @doctor_name = doctor.full_name
    @patient_name = "#{patient.first_name} #{patient.last_name}"
    @old_appointment_date = old_date
    @new_appointment_date = appointment_first.appointment_date
    @follow_up_date = appointment_first.follow_up_date
    @doctor_contact = doctor.contact_email || doctor.user.email
    @doctor_phone = doctor.contact_phone

    mail(to: patient.user.email, subject: 'Termín první návštěvy byl změněn')
  end

  # Úkol 11: Email notifikace pro stanovení termínu druhé návštěvy
  def second_appointment_scheduled_email(doctor, patient, appointment_second)
    @doctor_name = doctor.full_name
    @patient_name = "#{patient.first_name} #{patient.last_name}"
    @appointment_date = appointment_second.appointment_date
    @doctor_contact = doctor.contact_email || doctor.user.email
    @doctor_phone = doctor.contact_phone

    mail(to: patient.user.email, subject: 'Termín druhé návštěvy byl stanoven')
  end

  # Úkol 11: Email notifikace pro změnu termínu druhé návštěvy
  def second_appointment_updated_email(doctor, patient, appointment_second, old_date)
    @doctor_name = doctor.full_name
    @patient_name = "#{patient.first_name} #{patient.last_name}"
    @old_appointment_date = old_date
    @new_appointment_date = appointment_second.appointment_date
    @doctor_contact = doctor.contact_email || doctor.user.email
    @doctor_phone = doctor.contact_phone

    mail(to: patient.user.email, subject: 'Termín druhé návštěvy byl změněn')
  end
end
