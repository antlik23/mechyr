class AddConfirmedAtToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    User.all.each do |user|
      user.confirmation_token = Devise.friendly_token
      user.confirmation_sent_at = DateTime.now
      user.confirmed_at = DateTime.now
      user.save(validate: false)
    end
  end
end
