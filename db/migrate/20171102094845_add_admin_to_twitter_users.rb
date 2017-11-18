class AddAdminToTwitterUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :twitter_users, :admin, :boolean
  end
end
