# frozen_string_literal: true

module Api
  module V1
    class IciqFormsController < FormsController
      def allow_multiple_forms
        true
      end

      def form_specific_permission_check
        patient = current_devise_api_user.patient
        patient.allowed_to_create_iciq_form
      end

      def form_params
        params.fetch(:iciq_form, {}).permit(:leakage_frequency,
                                            :leakage_assessment,
                                            :leakage_severity,
                                            :never_leaks,
                                            :leaks_before_reaching_toilet,
                                            :leaks_when_coughing_or_sneezing,
                                            :leaks_during_sleep,
                                            :leaks_during_physical_activity,
                                            :leaks_after_urinating_and_dressing,
                                            :leaks_for_unknown_reasons,
                                            :constant_leakage,
                                            :patient_id)
      end
    end
  end
end
