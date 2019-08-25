class AddCheckboxtToWroks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :check_tomorrow, :boolean
  end
end
