class RemoveFromFirstAppointment < ActiveRecord::Migration[7.1]
  def change
    remove_column :appointment_firsts, :urinary_tract_infection, :boolean
    remove_column :appointment_firsts, :severe_pelvic_organ_prolapse, :boolean
  end
end
