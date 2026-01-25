class ChangeContinuingTreatmentToEnum < ActiveRecord::Migration[7.1]
  def change
    change_column :appointment_seconds, :continuing_treatment, :integer, using: 'CASE continuing_treatment WHEN TRUE THEN 1 ELSE 0 END'
  end
end
