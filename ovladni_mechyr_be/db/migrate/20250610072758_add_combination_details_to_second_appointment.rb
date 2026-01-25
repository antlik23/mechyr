class AddCombinationDetailsToSecondAppointment < ActiveRecord::Migration[7.1]
  def change
    add_column :appointment_seconds, :multiple_medications, :string
    add_column :appointment_seconds, :multiple_medications_dosage, :string
  end
end
