class CreateWorkRogs < ActiveRecord::Migration[5.1]
  def change
    create_table :work_rogs do |t|
      t.integer :user_id
      t.date :day
      t.datetime :leaving_time
      t.datetime :attendance_time
      t.datetime :attendance_after_chenge
      t.datetime :liaving_after_chenge
      t.string :change_request
      t.references :work, foreign_key: true

      t.timestamps
    end
  end
end
