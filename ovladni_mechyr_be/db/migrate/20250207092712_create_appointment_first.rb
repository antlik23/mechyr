class CreateAppointmentFirst < ActiveRecord::Migration[7.1]
  def change
    create_table :appointment_firsts do |t|
      t.datetime :appointment_date
      t.boolean :consent_signed
      t.boolean :meets_project_criteria
      t.boolean :clinical_assessment_completed
      t.boolean :prolapse_present
      t.boolean :stress_test_done
      t.boolean :stress_test_result
      t.boolean :uti_excluded
      t.integer :bladder_discomfort_vas
      t.integer :diagnosis
      t.string :alternative_diagnosis
      t.boolean :oab_treatment_criteria_met
      t.integer :prescribed_medication
      t.float :dosage
      t.integer :dosage_unit
      t.string :alternative_dosage_unit
      t.integer :reason_treatment_not_started
      t.string :alternative_treatment_details
      t.string :treatment_contraindications
      t.datetime :follow_up_date
      t.references :doctor, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
