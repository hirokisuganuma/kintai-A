class CreateWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :works do |t|
      t.datetime :attendance_time
      t.datetime :leaving_time
      t.date :day
      t.text :remarks
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
