# frozen_string_literal: true

module Api
  module V1
    class IpssFormsController < FormsController
      def allow_multiple_forms
        true
      end

      def form_specific_permission_check
        patient = current_devise_api_user.patient
        patient.allowed_to_create_ipss_form
      end

      def form_params
        params.fetch(:ipss_form, {}).permit(:incomplete_emptying,
                                            :frequency,
                                            :intermittent_urination,
                                            :urgency,
                                            :weak_stream,
                                            :straining,
                                            :nocturnal_urination,
                                            :quality_of_life,
                                            :patient_id)
      end
    end
  end
end
