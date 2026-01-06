class RemovePhoneNumberFromPatient < ActiveRecord::Migration[7.1]
  def change
    remove_column :patients, :phone_number, :string
    remove_column :patients, :preferred_contact, :integer
  end
end
