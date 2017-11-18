class AddPasswordDigestToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :twitter_users, :password_digest, :string
  end
end
