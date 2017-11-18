class AddLoginStatusToTwitterUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :twitter_users, :login_status, :integer
  end
end
