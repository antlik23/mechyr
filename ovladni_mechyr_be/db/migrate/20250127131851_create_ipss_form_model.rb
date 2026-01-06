class CreateIpssFormModel < ActiveRecord::Migration[7.1]
  def change
    create_table :ipss_forms do |t|
      t.integer :incomplete_emptying, null: true
      t.integer :frequency, null: true
      t.integer :intermittent_urination, null: true
      t.integer :urgency, null: true
      t.integer :weak_stream, null: true
      t.integer :straining, null: true
      t.integer :nocturnal_urination, null: true
      t.integer :total_score
      t.integer :quality_of_life
      t.boolean :completed, default: false
      t.datetime :completion_timestamp
      t.references :patient, foreign_key: true 
  
      t.timestamps
    end
  end
end
