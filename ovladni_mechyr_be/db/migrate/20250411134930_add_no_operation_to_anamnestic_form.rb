class AddNoOperationToAnamnesticForm < ActiveRecord::Migration[7.1]
  def change
    add_column :anamnestic_forms, :no_surgery, :boolean
    add_column :anamnestic_forms, :no_illness, :boolean
  end
end
