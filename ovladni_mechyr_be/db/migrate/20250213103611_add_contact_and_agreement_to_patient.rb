class AddContactAndAgreementToPatient < ActiveRecord::Migration[7.1]
  def change
    add_column :patients, :preferred_contact, :integer
    add_column :patients, :agreed_to_share_info, :boolean, default: false
  end
end
