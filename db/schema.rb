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

ActiveRecord::Schema.define(version: 20150812195511) do

  create_table "attaches", force: :cascade do |t|
    t.integer  "attachable_id",        limit: 4
    t.string   "attachable_type",      limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "content_file_name",    limit: 255
    t.string   "content_content_type", limit: 255
    t.integer  "content_file_size",    limit: 4
    t.datetime "content_updated_at"
  end

  create_table "channels", force: :cascade do |t|
    t.integer  "group_id",         limit: 4
    t.string   "name",             limit: 255, null: false
    t.string   "email",            limit: 255, null: false
    t.string   "list_id",          limit: 255
    t.string   "list_unsubscribe", limit: 255
    t.string   "list_subscribe",   limit: 255
    t.string   "list_post",        limit: 255
    t.string   "list_help",        limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "channels", ["group_id"], name: "index_channels_on_group_id", using: :btree

  create_table "channels_mailinglists", force: :cascade do |t|
    t.integer  "channel_id",     limit: 4
    t.integer  "mailinglist_id", limit: 4
    t.boolean  "is_read",        limit: 1, default: false
    t.boolean  "is_favorite",    limit: 1, default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "channels_mailinglists", ["channel_id"], name: "index_channels_mailinglists_on_channel_id", using: :btree
  add_index "channels_mailinglists", ["mailinglist_id"], name: "index_channels_mailinglists_on_mailinglist_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree

  create_table "mailinglists", force: :cascade do |t|
    t.integer  "origin_id",    limit: 4
    t.string   "message_id",   limit: 255
    t.string   "subject",      limit: 255
    t.text     "content",      limit: 4294967295
    t.datetime "date"
    t.string   "from",         limit: 255
    t.string   "from_name",    limit: 255
    t.string   "to",           limit: 255
    t.string   "reply_to",     limit: 255
    t.string   "cc",           limit: 255
    t.string   "bcc",          limit: 255
    t.string   "mime_version", limit: 255
    t.text     "origin_text",  limit: 4294967295
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "mailinglists", ["message_id"], name: "index_mailinglists_on_message_id", unique: true, using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "origin_id",    limit: 4
    t.string   "message_id",   limit: 255
    t.string   "subject",      limit: 255
    t.text     "content",      limit: 4294967295
    t.datetime "date"
    t.string   "from",         limit: 255
    t.string   "from_name",    limit: 255
    t.string   "to",           limit: 255
    t.string   "reply_to",     limit: 255
    t.string   "cc",           limit: 255
    t.string   "bcc",          limit: 255
    t.string   "mime_version", limit: 255
    t.text     "origin_text",  limit: 4294967295
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "messages", ["message_id"], name: "index_messages_on_message_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "uid",                    limit: 255, default: "", null: false
    t.string   "name",                   limit: 255, default: "", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

  create_table "users_channels", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "channel_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "users_messages", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "message_id",  limit: 4
    t.boolean  "is_read",     limit: 1, default: false
    t.boolean  "is_favorite", limit: 1, default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "users_messages", ["message_id"], name: "index_users_messages_on_message_id", using: :btree
  add_index "users_messages", ["user_id"], name: "index_users_messages_on_user_id", using: :btree

  add_foreign_key "channels", "groups"
  add_foreign_key "channels_mailinglists", "channels"
  add_foreign_key "channels_mailinglists", "mailinglists"
  add_foreign_key "users_messages", "messages"
  add_foreign_key "users_messages", "users"
end
