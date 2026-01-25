class CreateAnamnesticForms < ActiveRecord::Migration[7.1]
  def change
    create_table :anamnestic_forms do |t|
      t.datetime :completion_timestamp
      t.integer :age
      t.integer :height
      t.integer :weight
      t.boolean :on_oab_medication_last_3_months
      t.integer :number_of_births
      t.boolean :post_menopausal
      t.boolean :prolapse_diagnosed
      t.boolean :hysterectomy
      t.boolean :cesarean_section
      t.boolean :surgery_for_benign_prostate_enlargement
      t.boolean :surgery_for_prostate_cancer
      t.boolean :surgery_for_bladder_tumor
      t.boolean :surgery_for_urethral_stricture
      t.boolean :surgery_for_urine_leakage
      t.boolean :other_surgery
      t.string :previous_surgery_details
      t.boolean :recurrent_infections
      t.boolean :neurological_surgery_history
      t.boolean :hypertension
      t.boolean :hypothyroidism
      t.boolean :high_cholesterol
      t.boolean :diabetes
      t.boolean :back_problems
      t.boolean :depression
      t.boolean :other_psychiatric_conditions
      t.boolean :reduced_immunity
      t.boolean :headaches
      t.boolean :hip_osteoarthritis
      t.boolean :knee_osteoarthritis
      t.boolean :cancer_treatment_history
      t.boolean :cervical_cancer
      t.boolean :endometrial_cancer
      t.boolean :ovarian_cancer
      t.boolean :breast_cancer
      t.boolean :intestinal_cancer
      t.boolean :other_cancer
      t.string :cancer_type_details
      t.boolean :drug_allergies
      t.string :drug_allergies_details
      t.boolean :glaucoma_or_eye_pressure_meds
      t.boolean :cardiac_conditions
      t.boolean :heart_attack
      t.boolean :arrhythmia
      t.boolean :stroke
      t.boolean :digestive_problems
      t.boolean :dry_mucous_membranes
      t.boolean :current_medications
      t.string :current_medications_details
      t.boolean :past_medications
      t.string :past_medications_details
      t.boolean :completed
      t.references :patient, null: false, foreign_key: true 

      t.timestamps
    end
  end
end
