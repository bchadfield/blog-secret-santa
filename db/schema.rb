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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131215103718) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "content", force: true do |t|
    t.integer  "draw_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  add_index "content", ["draw_id"], name: "index_content_on_draw_id", using: :btree
  add_index "content", ["user_id"], name: "index_content_on_user_id", using: :btree

  create_table "draws", force: true do |t|
    t.datetime "match_time"
    t.datetime "gift_time"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.integer  "draw_id"
    t.integer  "giver_id"
    t.integer  "receiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["draw_id"], name: "index_matches_on_draw_id", using: :btree
  add_index "matches", ["giver_id"], name: "index_matches_on_giver_id", using: :btree
  add_index "matches", ["receiver_id"], name: "index_matches_on_receiver_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.string   "location"
    t.string   "url"
    t.string   "image"
    t.boolean  "admin"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree

end
