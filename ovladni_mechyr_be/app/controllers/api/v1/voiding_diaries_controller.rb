# frozen_string_literal: true

module Api
  module V1
    class VoidingDiariesController < FormsController
      def latest_diary
        return if authorize_action(roles: %i[patient])

        patient = current_devise_api_user.patient
        users_diaries = patient.voiding_diaries

        @allowed_to_create_voiding_diary = patient.allowed_to_create_voiding_diary ? true : false
        @form = users_diaries.last
      end

      def form_specific_permission_check
        patient = current_devise_api_user.patient
        patient = Patient.find(params[:voiding_diary][:patient_id]) if patient.nil?
        patient.allowed_to_create_voiding_diary
      end

      def update
        return if authorize_action(roles: update_permission)

        return render json: { error: I18n.t('errors.messages.cannot_edit_completed') }.to_json, status: :forbidden if @form.completed && !current_user_is_admin?

        authorize_doctor if current_user_is_doctor?

        if @form.update(form_params.except(:completed))
          return render json: { error: I18n.t('errors.messages.unable_to_complete') }.to_json, status: :forbidden unless set_completion

          render :update, status: :ok
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def create_permission
        %i[patient doctor]
      end

      def update_permission
        %i[admin doctor patient]
      end

      def allow_multiple_forms
        true
      end

      def form_params
        params.fetch(:voiding_diary, {}).permit(:diary_start_date,
                                                :diary_duration_days,
                                                :bedtime_day_one,
                                                :wake_up_time_day_one,
                                                :patient_id,
                                                :bedtime_day_two,
                                                :wake_up_time_day_two,
                                                :patient_id,
                                                :completed)
      end

      def set_completion
        return true unless params[:voiding_diary][:completed] == true

        day_one_status = @form.bedtime_day_one.present? && @form.wake_up_time_day_one.present?
        day_two_status = @form.bedtime_day_two.present? && @form.wake_up_time_day_two.present?
        duration = @form.diary_duration_days

        if day_one_status && (duration == 1 || day_two_status)
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity) unless @form.update(completed: true)

          true
        else
          false
        end
      end
    end
  end
end
