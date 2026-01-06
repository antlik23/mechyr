# frozen_string_literal: true

module Api
  module V1
    class DoctorsController < ApplicationController
      def available_doctors
        return if authorize_action(roles: %i[patient admin])

        doctors = if current_user_is_patient?
                    Doctor.where(full_capacity: false)
                          .where.not(full_name: nil)
                          .where.not(workplace: nil)
                          .where.not(contact_email: nil)
                          .where.not(contact_phone: nil)
                          .where.not(city: nil)
                          .where.not(postal_code: nil)
                          .where.not(street_and_number: nil)
                  else
                    Doctor.all
                  end

        @pagy, @doctors = pagy(DoctorsQuery.call(doctors, params).result.distinct, items: params[:items_per_page], page: page_param)
        @pagination = pagy_metadata(@pagy)
      end

      def update_full_capacity
        return if authorize_action(roles: %i[doctor])

        doctor = current_devise_api_user.doctor
        doctor.update(capacity_params)
        return unless (params[:doctor][:full_capacity] = true)

        patients_to_reject = doctor.patients.where(approved: false)
        patients_to_reject.each do |patient|
          patient.update(reject_params)
          UserMailer.reject_email(current_devise_api_user.doctor, patient).deliver_later
        end
      end

      private

      def capacity_params
        params.require(:doctor).permit(:full_capacity)
      end

      def reject_params
        { doctor_id: nil, agreed_to_share_info: nil }
      end
    end
  end
end
