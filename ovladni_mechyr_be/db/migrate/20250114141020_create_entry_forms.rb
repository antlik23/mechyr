class CreateEntryForms < ActiveRecord::Migration[7.1]
  def change
    create_table :entry_forms do |t|
      t.boolean :urination_frequency_issue
      t.integer :urinations_per_day
      t.float :fluid_intake_volume
      t.timestamps
    end
  end
end
