class FixPatientDoctorAssociation < ActiveRecord::Migration[7.1]
  def change
    remove_column :patients, :assigned_doctor_id, :integer

    add_column :patients, :doctor_id, :integer, null: true
    add_index :patients, :doctor_id
  end
end
