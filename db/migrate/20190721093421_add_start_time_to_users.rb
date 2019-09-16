class AddStartTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :designated_work_start_time, :datetime, default: Time.zone.parse("08:30")
  end
end
