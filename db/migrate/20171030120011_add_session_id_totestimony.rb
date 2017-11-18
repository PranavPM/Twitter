class AddSessionIdTotestimony < ActiveRecord::Migration[5.1]
  def change
    add_column :testimonies, :session_id, :string
  end
end
