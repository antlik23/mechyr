class RenameDiagnosesToDiagnosis < ActiveRecord::Migration[7.1]
  def change
    rename_column :appointment_initials, :diagnoses, :diagnosis
    rename_column :appointment_initials, :treatment_reason_not_started, :reason_treatment_not_started
  end
end
