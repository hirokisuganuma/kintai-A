class AddChangeinfoToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :attendance_after_chenge, :datetime
    add_column :works, :liaving_after_chenge, :datetime
  end
end
