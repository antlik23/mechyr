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
end
