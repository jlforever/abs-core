# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130804192810) do

  create_table "registrations", :force => true do |t|
    t.string   "class_level"
    t.string   "child_first_name"
    t.string   "child_last_name"
    t.datetime "child_dob"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "parent_first_name"
    t.string   "parent_last_name"
    t.string   "parent_day_phone"
    t.string   "parent_cell_phone"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_phone"
    t.string   "authorized_picked_up_by"
    t.string   "learned_from"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parent_email"
    t.string   "child_nick_name"
    t.string   "heard_from"
  end

end
