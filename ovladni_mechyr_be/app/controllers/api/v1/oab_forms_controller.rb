# frozen_string_literal: true

module Api
  module V1
    class OabFormsController < FormsController
      def allow_multiple_forms
        true
      end

      def form_params
        params.fetch(:oab_form, {}).permit(:daytime_urination_frequency,
                                           :unpleasant_urination_urge,
                                           :sudden_urination_urge,
                                           :occasional_leak,
                                           :nighttime_urination,
                                           :waking_up_to_urinate,
                                           :uncontrollable_urge,
                                           :leak_due_to_intense_urge,
                                           :patient_id)
      end
    end
  end
end
