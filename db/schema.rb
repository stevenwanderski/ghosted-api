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

ActiveRecord::Schema.define(version: 20150817004823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "issues", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "repo_id",                  null: false
    t.uuid     "milestone_id"
    t.text     "title",                    null: false
    t.text     "body"
    t.string   "state",                    null: false
    t.integer  "number",                   null: false
    t.integer  "issue_id",                 null: false
    t.integer  "weight",       default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "milestones", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "repo_id",                  null: false
    t.integer  "milestone_id",             null: false
    t.integer  "number",                   null: false
    t.string   "state",                    null: false
    t.text     "title",                    null: false
    t.text     "body"
    t.integer  "weight",       default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "repos", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "repo_id",                           null: false
    t.text     "name",                              null: false
    t.text     "full_name",                         null: false
    t.boolean  "favorite",          default: false
    t.boolean  "issues_loaded",     default: false
    t.boolean  "milestones_loaded", default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "repos", ["repo_id"], name: "index_repos_on_repo_id", unique: true, using: :btree

  create_table "user_repos", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",    null: false
    t.uuid     "repo_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "github_id",                              null: false
    t.string   "username",                               null: false
    t.string   "encrypted_access_token",                 null: false
    t.string   "avatar"
    t.boolean  "repos_loaded",           default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

end
