class CreateOabForms < ActiveRecord::Migration[7.1]
  def change
    create_table :oab_forms do |t|
      t.integer :daytime_urination_frequency
      t.integer :unpleasant_urination_urge
      t.integer :sudden_urination_urge
      t.integer :occasional_leak
      t.integer :nighttime_urination
      t.integer :waking_up_to_urinate
      t.integer :uncontrollable_urge
      t.integer :leak_due_to_intense_urge
      t.integer :total_score
      t.boolean :completed, default: false
      t.datetime :completion_timestamp
      t.references :patient, foreign_key: true 

      t.timestamps
    end
  end
end
