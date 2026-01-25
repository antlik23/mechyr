class ChangePatientToUseFullName < ActiveRecord::Migration[7.1]
  def change
    remove_column :patients, :last_name
    rename_column :patients, :first_name, :full_name
  end
end
