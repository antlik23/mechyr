class AddPatientIdToEntryForm < ActiveRecord::Migration[7.1]
  def change
    add_column :entry_forms, :patient_id, :integer, null: true
    add_index :entry_forms, :patient_id
  end
end
