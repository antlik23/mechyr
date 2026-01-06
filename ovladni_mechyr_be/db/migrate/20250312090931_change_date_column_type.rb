class ChangeDateColumnType < ActiveRecord::Migration[7.1]
  def change
    change_column :appointment_firsts, :appointment_date, :date
    change_column :appointment_firsts, :follow_up_date, :date
    change_column :appointment_initials, :assessment_date, :date
    change_column :appointment_seconds, :appointment_date, :date
  end
end
