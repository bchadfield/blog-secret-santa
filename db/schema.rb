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

ActiveRecord::Schema.define(version: 20150619034825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "content", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "match_id"
    t.string   "token",      limit: 255
    t.string   "title",      limit: 255
    t.text     "body"
    t.string   "url",        limit: 255
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "draw_id"
  end

  add_index "content", ["group_id"], name: "index_content_on_group_id", using: :btree
  add_index "content", ["match_id"], name: "index_content_on_match_id", using: :btree

  create_table "draws", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "draws", ["event_id"], name: "index_draws_on_event_id", using: :btree
  add_index "draws", ["group_id"], name: "index_draws_on_group_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "token",      limit: 255
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "giver_id"
    t.integer  "receiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "draw_id"
  end

  add_index "matches", ["giver_id"], name: "index_matches_on_giver_id", using: :btree
  add_index "matches", ["group_id"], name: "index_matches_on_group_id", using: :btree
  add_index "matches", ["receiver_id"], name: "index_matches_on_receiver_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "token",                  limit: 255
    t.string   "name",                   limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "email",                  limit: 255
    t.string   "location",               limit: 255
    t.string   "blog",                   limit: 255
    t.string   "image",                  limit: 255
    t.integer  "role"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
  end

  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "authentications", "users"
  add_foreign_key "content", "draws"
  add_foreign_key "draws", "events"
  add_foreign_key "draws", "groups"
  add_foreign_key "matches", "draws"
end
