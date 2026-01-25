class CreateIciqForms < ActiveRecord::Migration[7.1]
  def change
    create_table :iciq_forms do |t|
      t.integer :leakage_frequency
      t.integer :leakage_assessment
      t.integer :leakage_severity 
      t.boolean :never_leaks
      t.boolean :leaks_before_reaching_toilet
      t.boolean :leaks_when_coughing_or_sneezing
      t.boolean :leaks_during_sleep
      t.boolean :leaks_during_physical_activity
      t.boolean :leaks_after_urinating_and_dressing
      t.boolean :leaks_for_unknown_reasons
      t.boolean :constant_leakage
      t.integer :total_score
      t.boolean :completed
      t.datetime :completion_timestamp
      t.references :patient, null: false, foreign_key: true 

      t.timestamps
    end
  end
end
