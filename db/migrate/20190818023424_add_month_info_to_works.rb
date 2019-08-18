class AddMonthInfoToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :month_request, :string
  end
end
