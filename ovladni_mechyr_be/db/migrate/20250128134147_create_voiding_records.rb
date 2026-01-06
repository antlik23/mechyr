class CreateVoidingRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :voiding_records do |t|
      t.datetime :recorded_at
      t.boolean :slept_before_and_after
      t.boolean :urine_leakage
      t.boolean :felt_urge_before
      t.integer :urge_strength
      t.integer :urine_volume
      t.integer :beverage_type
      t.integer :fluid_intake
      t.references :voiding_diary, null: false, foreign_key: true 

      t.timestamps
    end
  end
end
