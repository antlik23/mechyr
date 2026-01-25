class AddNextAppointmentToPatient < ActiveRecord::Migration[7.1]
  def change
    add_column :patients, :next_appointment, :datetime
  end
end
