class CreateAppointmentSecond < ActiveRecord::Migration[7.1]
  def change
    create_table :appointment_seconds do |t|
      t.boolean :attended_appointment
      t.datetime :appointment_date
      t.boolean :continuing_treatment
      t.integer :discontinuation_reason
      t.string :alternative_reason
      t.integer :current_treatment
      t.integer :prescribed_medication
      t.float :dosage
      t.integer :dosage_unit
      t.string :alternative_dosage_unit
      t.references :doctor, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
