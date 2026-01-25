class AddEntryTreatmentToAppointmentFirst < ActiveRecord::Migration[7.1]
  def change
    add_column :appointment_firsts, :blood_in_urine, :boolean
    add_column :appointment_firsts, :protein_in_urine, :boolean
    add_column :appointment_firsts, :sugar_in_urine, :boolean
    add_column :appointment_firsts, :urinary_tract_infection, :boolean
    add_column :appointment_firsts, :severe_pelvic_organ_prolapse, :boolean
    add_column :appointment_firsts, :post_void_residual_over_100_ml, :boolean
  end
end
