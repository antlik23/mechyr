class AddApprovedToPatient < ActiveRecord::Migration[7.1]
  def change
    add_column(:patients, :approved, :boolean)
  end
end
