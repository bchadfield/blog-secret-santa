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

ActiveRecord::Schema.define(version: 20141017094021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "content", force: true do |t|
    t.integer  "pool_id"
    t.integer  "match_id"
    t.string   "token"
    t.string   "title"
    t.text     "body"
    t.string   "url"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content", ["match_id"], name: "index_content_on_match_id", using: :btree
  add_index "content", ["pool_id"], name: "index_content_on_pool_id", using: :btree

  create_table "matches", force: true do |t|
    t.integer  "pool_id"
    t.integer  "giver_id"
    t.integer  "receiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["giver_id"], name: "index_matches_on_giver_id", using: :btree
  add_index "matches", ["pool_id"], name: "index_matches_on_pool_id", using: :btree
  add_index "matches", ["receiver_id"], name: "index_matches_on_receiver_id", using: :btree

  create_table "pools", force: true do |t|
    t.string   "token"
    t.string   "name"
    t.string   "subdomain"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "pool_id"
    t.string   "token"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.string   "location"
    t.string   "blog"
    t.string   "image"
    t.integer  "role"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
  end

  add_index "users", ["pool_id"], name: "index_users_on_pool_id", using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
