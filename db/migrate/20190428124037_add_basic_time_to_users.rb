class AddBasicTimeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :basic_work_time, :time, default: Time.zone.parse("07:30")
  end
end
