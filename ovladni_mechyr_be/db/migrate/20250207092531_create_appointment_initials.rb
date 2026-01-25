class CreateAppointmentInitials < ActiveRecord::Migration[7.1]
  def change
    create_table :appointment_initials do |t|
      t.datetime :assessment_date
      t.integer :diagnoses
      t.string :alternative_diagnosis
      t.boolean :oab_treatment_criteria_met
      t.boolean :initiate_pharmacological_treatment
      t.integer :prescribed_medication
      t.float :dosage
      t.integer :dosage_unit
      t.string :alternative_dosage_unit
      t.integer :treatment_reason_not_started
      t.string :alternative_treatment_details
      t.references :doctor, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
