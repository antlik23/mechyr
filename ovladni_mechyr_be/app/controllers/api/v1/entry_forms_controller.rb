# frozen_string_literal: true

module Api
  module V1
    class EntryFormsController < FormsController
      skip_before_action :authenticate_devise_api_token!, only: :create
      def create
        @form = EntryForm.new(form_params)
        if @form.save
          @message = I18n.t('success.messages.created', resource: 'EntryForm')
          render :create, status: :created
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def form_params
        params.fetch(:entry_form, {}).permit(:urination_frequency_issue, :urinations_per_day, :fluid_intake_volume)
      end
    end
  end
end
