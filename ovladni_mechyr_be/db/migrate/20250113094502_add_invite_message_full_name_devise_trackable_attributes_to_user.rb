class AddInviteMessageFullNameDeviseTrackableAttributesToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :full_name, :string
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :invite_message, :text
  end
end
