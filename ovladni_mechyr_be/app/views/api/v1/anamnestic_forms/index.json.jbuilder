# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.anamnestic_forms @forms do |anamnestic_form|
  json.id anamnestic_form.id
  json.completion_timestamp anamnestic_form.completion_timestamp
  json.age anamnestic_form.age
  json.height anamnestic_form.height
  json.weight anamnestic_form.weight
  json.on_oab_medication_last_3_months anamnestic_form.on_oab_medication_last_3_months
  json.number_of_births anamnestic_form.number_of_births
  json.post_menopausal anamnestic_form.post_menopausal
  json.prolapse_diagnosed anamnestic_form.prolapse_diagnosed
  json.hysterectomy anamnestic_form.hysterectomy
  json.cesarean_section anamnestic_form.cesarean_section
  json.surgery_for_benign_prostate_enlargement anamnestic_form.surgery_for_benign_prostate_enlargement
  json.surgery_for_prostate_cancer anamnestic_form.surgery_for_prostate_cancer
  json.surgery_for_bladder_tumor anamnestic_form.surgery_for_bladder_tumor
  json.surgery_for_urethral_stricture anamnestic_form.surgery_for_urethral_stricture
  json.surgery_for_urine_leakage anamnestic_form.surgery_for_urine_leakage
  json.no_surgery anamnestic_form.no_surgery
  json.other_surgery anamnestic_form.other_surgery
  json.previous_surgery_details anamnestic_form.previous_surgery_details
  json.recurrent_infections anamnestic_form.recurrent_infections
  json.neurological_surgery_history anamnestic_form.neurological_surgery_history
  json.hypertension anamnestic_form.hypertension
  json.hypothyroidism anamnestic_form.hypothyroidism
  json.high_cholesterol anamnestic_form.high_cholesterol
  json.diabetes anamnestic_form.diabetes
  json.back_problems anamnestic_form.back_problems
  json.depression anamnestic_form.depression
  json.other_psychiatric_conditions anamnestic_form.other_psychiatric_conditions
  json.reduced_immunity anamnestic_form.reduced_immunity
  json.headaches anamnestic_form.headaches
  json.hip_osteoarthritis anamnestic_form.hip_osteoarthritis
  json.knee_osteoarthritis anamnestic_form.knee_osteoarthritis
  json.cancer_treatment_history anamnestic_form.cancer_treatment_history
  json.cervical_cancer anamnestic_form.cervical_cancer
  json.endometrial_cancer anamnestic_form.endometrial_cancer
  json.ovarian_cancer anamnestic_form.ovarian_cancer
  json.breast_cancer anamnestic_form.breast_cancer
  json.intestinal_cancer anamnestic_form.intestinal_cancer
  json.other_cancer anamnestic_form.other_cancer
  json.cancer_type_details anamnestic_form.cancer_type_details
  json.drug_allergies anamnestic_form.drug_allergies
  json.drug_allergies_details anamnestic_form.drug_allergies_details
  json.glaucoma_or_eye_pressure_meds anamnestic_form.glaucoma_or_eye_pressure_meds
  json.cardiac_conditions anamnestic_form.cardiac_conditions
  json.heart_attack anamnestic_form.heart_attack
  json.arrhythmia anamnestic_form.arrhythmia
  json.stroke anamnestic_form.stroke
  json.digestive_problems anamnestic_form.digestive_problems
  json.dry_mucous_membranes anamnestic_form.dry_mucous_membranes
  json.no_illness anamnestic_form.no_illness
  json.current_medications anamnestic_form.current_medications
  json.current_medications_details anamnestic_form.current_medications_details
  json.past_medications anamnestic_form.past_medications
  json.past_medications_details anamnestic_form.past_medications_details
  json.completed anamnestic_form.completed
end
