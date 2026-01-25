# frozen_string_literal: true

module Api
  module V1
    class AppointmentSecondsController < AppointmentsController
      def update_permission
        %i[doctor admin]
      end

      def form_params
        params.fetch(:appointment_second, {}).permit(:attended_appointment,
                                                     :appointment_date,
                                                     :continuing_treatment,
                                                     :discontinuation_reason,
                                                     :alternative_reason,
                                                     :current_treatment,
                                                     :prescribed_medication,
                                                     :dosage,
                                                     :dosage_unit,
                                                     :alternative_dosage_unit,
                                                     :visual_analog_scale,
                                                     :patient_id,
                                                     :notes,
                                                     :multiple_medications,
                                                     :multiple_medications_dosage)
      end
    end
  end
end
