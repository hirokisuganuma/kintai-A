class AddEndTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :designated_end_time, :datetime, default: Time.zone.parse("17:30")
  end
end
