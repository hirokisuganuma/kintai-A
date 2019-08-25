class AddChangeinfoToWoks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :change_request, :string
  end
end
