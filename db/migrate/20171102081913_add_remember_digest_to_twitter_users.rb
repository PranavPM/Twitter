class AddRememberDigestToTwitterUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :twitter_users, :remember_digest, :string
  end
end
