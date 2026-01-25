# frozen_string_literal: true

module Api
  module V1
    class SignupsController < Devise::Api::TokensController
      # rubocop:disable Metrics/AbcSize
      def create
        set_gender if params[:user][:roles] == ['patient']

        unless Devise.api.config.sign_up.enabled
          error_response = Devise::Api::Responses::ErrorResponse.new(request, error: :sign_up_disabled, resource_class:)

          return render json: error_response.body, status: error_response.status
        end
        Devise.api.config.before_sign_up.call(sign_up_params.except(:roles), request, resource_class)

        service = Devise::Api::ResourceOwnerService::SignUp.new(params: sign_up_params.except(:roles), resource_class:).call

        if service.success?
          @token = service.success

          call_devise_trackable!(@token.resource_owner)

          Devise::Api::Responses::TokenResponse.new(request, token: @token, action: __method__)

          Devise.api.config.after_successful_sign_up.call(@token.resource_owner, @token, request)

          save_roles(@token.resource_owner)
          update_entry_form(params[:entry_form].to_i) if params[:entry_form].present?
          return head :no_content
        end
        error_response = Devise::Api::Responses::ErrorResponse.new(request,
                                                                   resource_class:,
                                                                   **service.failure)
        render json: { error: error_response.body[:error_description].join(', ') }, status: error_response.status
      end

      def sanitized_params
        params.require(:user)
      end

      def sign_up_params
        sanitized_params.permit(
          *Devise.api.config.sign_up.extra_fields,
          *resource_class.authentication_keys,
          *user_params,
          *::Devise::ParameterSanitizer::DEFAULT_PERMITTED_ATTRIBUTES[:sign_up]
        ).to_h
      end
      # rubocop:enable Metrics/AbcSize

      private

      def save_roles(user)
        return true if params[:user][:roles].blank?

        params[:user][:roles].each do |role|
          next unless Role::ALL_ROLES.include?(role.to_sym)

          user.add_role(role.to_sym)
        end
      end

      def set_gender
        patient_params = params[:user][:patient_attributes]
        patient_params[:gender] = patient_params[:other_gender] if patient_params[:gender] == 'other'
        patient_params.delete(:other_gender)
      end

      def add_gender(user)
        user.patient.update(gender: params[:user][:other_gender]) if params[:user][:gender] == 'other'
      end

      def update_entry_form(entry_form_id)
        entry_form = EntryForm.find(entry_form_id)
        patient = @token.resource_owner.patient
        entry_form.update(patient_id: patient.id)
      end

      def user_params
        [{ roles: [],
           patient_attributes: %i[gender other_gender],
           doctor_attributes: %i[full_name
                                 workplace
                                 contact_email
                                 contact_phone
                                 city
                                 postal_code
                                 street_and_number
                                 user_id
                                 full_capacity
                                 latitude
                                 longitude] }]
      end
    end
  end
end
