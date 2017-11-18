class AddIndexToTwitterUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :twitter_users, :email, unique: true
  end
end
