# frozen_string_literal: true

module Api
  module V1
    class VoidingRecordsController < ApplicationController
      before_action :form, only: %i[destroy update show]

      def index
        authorize_form_access(voiding_diary)
        @pagy, @forms = pagy(VoidingRecordQuery.call(voiding_diary.voiding_records.all, params).result.distinct, items: params[:items_per_page], page: page_param)
        @pagination = pagy_metadata(@pagy)
      end

      def show; end

      def create
        return if authorize_action(roles: %i[patient doctor admin])

        return render json: { error: I18n.t('errors.messages.cannot_edit_completed') }.to_json, status: :forbidden if voiding_diary.completed && !current_user_is_admin?

        @form = voiding_diary.voiding_records.new(form_params)
        if @form.save
          @message = I18n.t('success.messages.created', resource: VoidingRecord.to_s)
          render :create, status: :created
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def update
        return render json: { error: I18n.t('errors.messages.cannot_edit_completed') }.to_json, status: :forbidden if voiding_diary.completed && !current_user_is_admin?

        if @form.update(form_params)
          render :update, status: :ok
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def destroy
        return if authorize_action(roles: %i[admin doctor patient])

        return render json: { error: I18n.t('errors.messages.cannot_edit_completed') }.to_json, status: :forbidden if voiding_diary.completed && !current_user_is_admin?

        if @form.destroy!
          head :no_content
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      private

      def voiding_diary
        VoidingDiary.find(params[:voiding_diary_id])
      end

      def authorize_form_access(form)
        if (current_user_is_patient? && form.patient != current_devise_api_user.patient) ||
           (current_user_is_doctor? && form.patient.doctor != current_devise_api_user.doctor)
          render json: { error: I18n.t('errors.messages.not_found') }.to_json, status: :not_found
        end
      end

      def form
        @form ||= VoidingRecord.find(params[:id])
        authorize_form_access(@form.voiding_diary)
      end

      def form_params
        params.fetch(:voiding_record, {}).permit(:recorded_at,
                                                 :slept_before_and_after,
                                                 :urine_leakage,
                                                 :urine_leakage_type,
                                                 :urge_strength,
                                                 :urine_volume,
                                                 :beverage_type,
                                                 :fluid_intake,
                                                 :voiding_diary_id)
      end
    end
  end
end
