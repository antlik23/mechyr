class CreateDoctors < ActiveRecord::Migration[7.1]
  def change
    create_table :doctors do |t|
      t.string :full_name
      t.string :workplace
      t.string :contact_email
      t.string :contact_phone
      t.string :city
      t.text :working_hours, default: 'PO: 7:00 - 14:00\nUT: 7:00 - 12:00\nST: 9:00 - 17:00\nCT: 7:00 - 11:00 13:00 - 17:00\nPA: 9:00 - 12:00\nSO: Zavřeno\nNE: Zavřeno'
      t.integer :postal_code
      t.string :street_and_number
      t.integer :user_id
      t.boolean :full_capacity, default: false
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :doctors, :user_id, unique: true
  end
end
