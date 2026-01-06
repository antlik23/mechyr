class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :first_name, null: true
      t.string :last_name, null: true
      t.integer :assigned_doctor_id, null: true
      t.string :phone_number, null: true
      t.integer :user_id, null: false
      t.integer :oab_form_id, null: true
      t.integer :iciq_form_id, null: true
      t.integer :ipss_form_id, null: true
      t.integer :anamnestic_form_id, null: true
      t.integer :entry_form_id, null: true
      t.integer :gender, null: false

      t.timestamps
    end

    add_index :patients, :user_id
    add_index :patients, :assigned_doctor_id
  end

end