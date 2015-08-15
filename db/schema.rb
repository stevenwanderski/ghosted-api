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

ActiveRecord::Schema.define(version: 20150814161603) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "repos", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "repo_id",                 null: false
    t.string   "name",                    null: false
    t.jsonb    "meta",       default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "repos", ["repo_id"], name: "index_repos_on_repo_id", unique: true, using: :btree

  create_table "user_repos", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",    null: false
    t.uuid     "repo_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "github_id",                           null: false
    t.string   "username",                            null: false
    t.string   "avatar",                              null: false
    t.string   "encrypted_access_token",              null: false
    t.jsonb    "meta",                   default: {}
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

end
