class AddNotesToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointment_firsts, :notes, :string
    add_column :appointment_seconds, :notes, :string
  end
end
