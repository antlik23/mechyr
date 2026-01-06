class AddWebToDoctor < ActiveRecord::Migration[7.1]
  def change
    add_column :doctors, :web, :string
  end
end
