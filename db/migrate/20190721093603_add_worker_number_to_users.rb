class AddWorkerNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :worker_number, :integer
  end
end
