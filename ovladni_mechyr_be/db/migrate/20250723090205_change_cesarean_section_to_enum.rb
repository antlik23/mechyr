class ChangeCesareanSectionToEnum < ActiveRecord::Migration[7.1]
  def change
    change_column :anamnestic_forms, :cesarean_section, :integer, using: 'cesarean_section::integer'
  end
end
