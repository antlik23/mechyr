class RemoveFormsIdsFromPatient < ActiveRecord::Migration[7.1]
  def change
    remove_column :patients, :oab_form_id
    remove_column :patients, :iciq_form_id
    remove_column :patients, :ipss_form_id
    remove_column :patients, :anamnestic_form_id
    remove_column :patients, :entry_form_id
  end
end
