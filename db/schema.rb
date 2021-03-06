# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190916112715) do

  create_table "bases", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "affiliation"
    t.time "basic_work_time", default: "2000-01-01 22:30:00"
    t.time "specified_time", default: "2000-01-01 23:00:00"
    t.boolean "admin", default: false
    t.boolean "superior"
    t.datetime "designated_work_start_time", default: "2019-09-15 23:30:00"
    t.datetime "designated_work_end_time", default: "2019-09-16 08:30:00"
    t.integer "employee_number"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "work_rogs", force: :cascade do |t|
    t.integer "user_id"
    t.date "day"
    t.datetime "leaving_time"
    t.datetime "attendance_time"
    t.datetime "attendance_after_chenge"
    t.datetime "liaving_after_chenge"
    t.string "change_request"
    t.integer "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id"], name: "index_work_rogs_on_work_id"
  end

  create_table "works", force: :cascade do |t|
    t.datetime "attendance_time"
    t.datetime "leaving_time"
    t.date "day"
    t.text "remarks"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "over_time_work"
    t.datetime "over_time_end"
    t.string "over_time_instructor"
    t.string "over_time_request"
    t.boolean "check_box"
    t.string "month_request"
    t.string "change_request"
    t.boolean "check_tomorrow"
    t.datetime "attendance_after_chenge"
    t.datetime "liaving_after_chenge"
    t.index ["user_id"], name: "index_works_on_user_id"
  end

end
