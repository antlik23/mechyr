# frozen_string_literal: true

module Api
  module V1
    class FormsController < ApplicationController
      before_action :form, only: %i[destroy update]

      def index
        return if authorize_action(roles: index_permission)

        forms = if current_user_is_patient?
                  form_class.where(patient_id: current_devise_api_user.patient.id)
                else
                  form_class.all
                end

        @pagy, @forms = pagy(form_query.call(forms, params).result.distinct, items: params[:items_per_page], page: page_param)
        @pagination = pagy_metadata(@pagy)
      end

      def show
        return if authorize_action(roles: show_permission)

        form
      end

      def create
        return if authorize_action(roles: create_permission)

        set_patient_from_user if params[resource_name][:user_id].present?

        return render json: { error: I18n.t("errors.messages.condition_not_met_#{controller_name}") }.to_json, status: :forbidden unless form_specific_permission_check

        return if authorize_doctor

        return render json: { error: I18n.t('errors.messages.duplicate') }.to_json, status: :forbidden unless check_for_previous_form

        @form = form_class.new(form_params)
        set_patient
        if @form.save
          @message = I18n.t('success.messages.created', resource: form_class.to_s)
          render :create, status: :created
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def update
        return if authorize_action(roles: update_permission)

        return if authorize_doctor

        if @form.update(form_params)
          render :update, status: :ok
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def destroy
        return if authorize_action(roles: destroy_permission)

        if @form.destroy!
          head :no_content
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      private

      def form_specific_permission_check
        true
      end

      def form_class
        controller_name.classify.constantize
      end

      def form_query
        "#{form_class}Query".constantize
      end

      def set_patient
        return if @form.patient_id.present?

        patient = current_devise_api_user.patient
        @form.update(patient_id: patient.id) unless patient.nil?
      end

      def check_for_previous_form
        return true if allow_multiple_forms

        patient = current_devise_api_user.patient.presence || Patient.find(params[resource_name][:patient_id])
        true if patient&.send(resource_name).blank?
      end

      def authorize_form_access
        if (current_user_is_patient? && @form.patient != current_devise_api_user.patient) ||
           (current_user_is_doctor? && @form.patient.doctor != current_devise_api_user.doctor)
          render json: { error: I18n.t('errors.messages.not_found') }.to_json, status: :not_found
        end
      end

      def authorize_doctor
        return unless current_user_is_doctor?

        patient = @form&.patient
        patient = Patient.find(params[resource_name][:patient_id]) if patient.nil?
        permitted = patient.doctor == current_devise_api_user.doctor
        render json: { error: I18n.t('errors.messages.not_found') }.to_json, status: :not_found unless permitted
      end

      def form
        @form ||= form_class.find(params[:id])
        authorize_form_access
      end

      def index_permission
        %i[admin patient]
      end

      def show_permission
        %i[admin patient doctor]
      end

      def create_permission
        %i[patient]
      end

      def update_permission
        %i[admin patient]
      end

      def destroy_permission
        %i[admin]
      end

      def allow_multiple_forms
        false
      end
    end
  end
end
