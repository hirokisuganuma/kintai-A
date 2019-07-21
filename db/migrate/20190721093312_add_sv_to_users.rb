class AddSvToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sv, :boolean
  end
end
