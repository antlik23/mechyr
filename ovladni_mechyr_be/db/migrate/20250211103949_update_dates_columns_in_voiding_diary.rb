class UpdateDatesColumnsInVoidingDiary < ActiveRecord::Migration[7.1]
  def change
    rename_column :voiding_diaries, :usual_bedtime, :bedtime_day_one
    rename_column :voiding_diaries, :usual_wake_up_time, :wake_up_time_day_one
    add_column :voiding_diaries, :bedtime_day_two, :time
    add_column :voiding_diaries, :wake_up_time_day_two, :time
    add_column :voiding_diaries, :completed, :boolean, default: false
  end
end
