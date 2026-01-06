class CreateVoidingDiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :voiding_diaries do |t|
      t.date :diary_start_date, null: false
      t.integer :diary_duration_days, null: false
      t.time :usual_bedtime
      t.time :usual_wake_up_time
      t.references :patient, null: false, foreign_key: true 

      t.timestamps
    end
  end
end
