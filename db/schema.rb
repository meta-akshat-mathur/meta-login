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

ActiveRecord::Schema.define(version: 20170118050341) do

  create_table "comments", force: :cascade do |t|
    t.string   "body",       limit: 255
    t.integer  "upvotes",    limit: 4
    t.integer  "post_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "one_time_passwords", force: :cascade do |t|
    t.string   "mobile",       limit: 255,             null: false
    t.string   "otp_code",     limit: 20,              null: false
    t.datetime "suspended_at"
    t.integer  "send_count",   limit: 4,   default: 0, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "one_time_passwords", ["mobile"], name: "index_one_time_passwords_on_mobile", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "link",       limit: 255
    t.integer  "upvotes",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "user_logins", force: :cascade do |t|
    t.string   "provider",           limit: 255
    t.string   "uid",                limit: 255, default: ""
    t.integer  "user_id",            limit: 4,                null: false
    t.string   "token",              limit: 255
    t.string   "secret",             limit: 255
    t.integer  "sign_in_count",      limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip", limit: 255
    t.string   "last_sign_in_ip",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_logins", ["uid", "provider"], name: "index_user_logins_on_uid_and_provider", unique: true, using: :btree
  add_index "user_logins", ["user_id"], name: "index_user_logins_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                           limit: 255
    t.string   "last_name",                            limit: 255
    t.string   "email",                                limit: 255
    t.date     "dob"
    t.string   "mobile",                               limit: 255
    t.datetime "mobile_confirmed_at"
    t.string   "gender",                               limit: 255
    t.string   "image",                                limit: 255
    t.string   "address",                              limit: 255
    t.integer  "state_id",                             limit: 4
    t.integer  "district_id",                          limit: 4
    t.integer  "city_id",                              limit: 4
    t.string   "pincode",                              limit: 6
    t.boolean  "is_permanent_address_same_as_current"
    t.string   "permanent_address",                    limit: 255
    t.integer  "permanent_state_id",                   limit: 4
    t.integer  "permanent_district_id",                limit: 4
    t.integer  "permanent_city_id",                    limit: 4
    t.string   "permanent_pincode",                    limit: 6
    t.boolean  "is_email_valid"
    t.datetime "skip_suspended_at"
    t.text     "permission_token",                     limit: 65535
    t.string   "status",                               limit: 255,   default: "active"
    t.integer  "resource_id",                          limit: 4
    t.string   "resource_type",                        limit: 255
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.string   "encrypted_password",                   limit: 255,   default: ""
    t.string   "reset_password_token",                 limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        limit: 4,     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",                   limit: 255
    t.string   "last_sign_in_ip",                      limit: 255
    t.string   "confirmation_token",                   limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",                    limit: 255
    t.string   "invitation_token",                     limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",                     limit: 4
    t.integer  "invited_by_id",                        limit: 4
    t.string   "invited_by_type",                      limit: 255
    t.integer  "invitations_count",                    limit: 4,     default: 0
    t.text     "tokens",                               limit: 65535
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["district_id"], name: "index_users_on_district_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["mobile"], name: "index_users_on_mobile", using: :btree
  add_index "users", ["mobile_confirmed_at"], name: "index_users_on_mobile_confirmed_at", using: :btree
  add_index "users", ["permanent_city_id"], name: "index_users_on_permanent_city_id", using: :btree
  add_index "users", ["permanent_district_id"], name: "index_users_on_permanent_district_id", using: :btree
  add_index "users", ["permanent_state_id"], name: "index_users_on_permanent_state_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["resource_type", "resource_id"], name: "index_users_on_resource_type_and_resource_id", using: :btree
  add_index "users", ["skip_suspended_at"], name: "index_users_on_skip_suspended_at", using: :btree
  add_index "users", ["state_id"], name: "index_users_on_state_id", using: :btree

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "posts", "users"
end
