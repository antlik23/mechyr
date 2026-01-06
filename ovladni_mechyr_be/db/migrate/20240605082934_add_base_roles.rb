class AddBaseRoles < ActiveRecord::Migration[7.1]
  def change
    Roles::CreateDefaults.call
  end
end
