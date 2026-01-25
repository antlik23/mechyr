class UpdateDefaultWorkingHoursOnDoctor < ActiveRecord::Migration[7.1]
  def change
    change_column_default :doctors, :working_hours, "PO: 7:00 - 14:00\nUT: 7:00 - 12:00\nST: 9:00 - 17:00\nCT: 7:00 - 11:00 13:00 - 17:00\nPA: 9:00 - 12:00\nSO: Zavřeno\nNE: Zavřeno"
  end
end
