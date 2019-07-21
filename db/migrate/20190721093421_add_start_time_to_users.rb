class AddStartTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :start_time, :datetime
  end
end
