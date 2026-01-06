class AddVisualAnalogScaleToAppointmentSecond < ActiveRecord::Migration[7.1]
  def change
    add_column :appointment_seconds, :visual_analog_scale, :integer
  end
end
