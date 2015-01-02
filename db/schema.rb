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

ActiveRecord::Schema.define(version: 20150102000539) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", force: true do |t|
    t.string   "title"
    t.text     "statement"
    t.text     "solution"
    t.integer  "status",     default: 0
    t.integer  "difficulty", default: 0
    t.integer  "domain_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problems", ["author_id"], name: "index_problems_on_author_id", using: :btree
  add_index "problems", ["difficulty"], name: "index_problems_on_difficulty", using: :btree
  add_index "problems", ["domain_id", "status", "difficulty"], name: "index_problems_on_domain_id_and_status_and_difficulty", using: :btree
  add_index "problems", ["domain_id", "status"], name: "index_problems_on_domain_id_and_status", using: :btree
  add_index "problems", ["domain_id"], name: "index_problems_on_domain_id", using: :btree
  add_index "problems", ["status"], name: "index_problems_on_status", using: :btree
  add_index "problems", ["updated_at"], name: "index_problems_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook"
    t.string   "school"
    t.boolean  "admin",               default: false
    t.boolean  "master",              default: false
    t.integer  "status",              default: 0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["updated_at"], name: "index_users_on_updated_at", using: :btree
  add_index "users", ["username", "master"], name: "index_users_on_username_and_master", using: :btree
  add_index "users", ["username", "status"], name: "index_users_on_username_and_status", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
