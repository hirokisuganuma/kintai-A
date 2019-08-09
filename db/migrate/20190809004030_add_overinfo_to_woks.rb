class AddOverinfoToWoks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :over_time_work, :string
    add_column :works, :over_time_end, :datetime
    add_column :works, :over_time_instructor, :string
    add_column :works, :over_time_request, :string
  end
end
