class ChangeFeltUrgeBeforeToUrineLeagakeType < ActiveRecord::Migration[7.1]
  def change
    remove_column :voiding_records, :felt_urge_before
    add_column :voiding_records, :urine_leakage_type, :integer
  end
end
