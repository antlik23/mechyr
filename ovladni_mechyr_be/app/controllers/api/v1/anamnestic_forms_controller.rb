# frozen_string_literal: true

module Api
  module V1
    class AnamnesticFormsController < FormsController
      def allow_multiple_forms
        true
      end

      def form_specific_permission_check
        patient = current_devise_api_user.patient
        patient.allowed_to_create_anamnestic_form
      end

      def update_permission
        %i[admin doctor patient]
      end

      def form_params
        params.fetch(:anamnestic_form, {}).permit(:completion_timestamp,
                                                  :age,
                                                  :height,
                                                  :weight,
                                                  :on_oab_medication_last_3_months,
                                                  :number_of_births,
                                                  :post_menopausal,
                                                  :prolapse_diagnosed,
                                                  :hysterectomy,
                                                  :cesarean_section,
                                                  :surgery_for_benign_prostate_enlargement,
                                                  :surgery_for_prostate_cancer,
                                                  :surgery_for_bladder_tumor,
                                                  :surgery_for_urethral_stricture,
                                                  :surgery_for_urine_leakage,
                                                  :other_surgery,
                                                  :previous_surgery_details,
                                                  :recurrent_infections,
                                                  :neurological_surgery_history,
                                                  :hypertension,
                                                  :hypothyroidism,
                                                  :high_cholesterol,
                                                  :diabetes,
                                                  :back_problems,
                                                  :depression,
                                                  :other_psychiatric_conditions,
                                                  :reduced_immunity,
                                                  :headaches,
                                                  :hip_osteoarthritis,
                                                  :knee_osteoarthritis,
                                                  :cancer_treatment_history,
                                                  :cervical_cancer,
                                                  :endometrial_cancer,
                                                  :ovarian_cancer,
                                                  :breast_cancer,
                                                  :intestinal_cancer,
                                                  :other_cancer,
                                                  :cancer_type_details,
                                                  :drug_allergies,
                                                  :drug_allergies_details,
                                                  :glaucoma_or_eye_pressure_meds,
                                                  :cardiac_conditions,
                                                  :heart_attack,
                                                  :arrhythmia,
                                                  :stroke,
                                                  :digestive_problems,
                                                  :dry_mucous_membranes,
                                                  :current_medications,
                                                  :current_medications_details,
                                                  :past_medications,
                                                  :past_medications_details,
                                                  :completed,
                                                  :patient_id,
                                                  :no_surgery,
                                                  :no_illness)
      end
    end
  end
end
