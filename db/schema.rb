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

ActiveRecord::Schema.define(version: 20170515142616) do

  create_table "access_scopes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string "code", limit: 45, null: false
  end

  create_table "countries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string "code", limit: 45, null: false
  end

  create_table "followings", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.bigint   "owner_id",   null: false
    t.bigint   "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_followings_on_deleted_at", using: :btree
    t.index ["owner_id", "user_id"], name: "index_followings_on_owner_id_and_user_id", unique: true, using: :btree
    t.index ["user_id"], name: "fk_rails_40463234d9", using: :btree
  end

  create_table "profiles", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.bigint   "user_id",                                null: false
    t.string   "name",                     limit: 128,   null: false
    t.text     "about_me",                 limit: 65535
    t.string   "img_dir_prefix",           limit: 8,     null: false
    t.string   "avator_image"
    t.string   "background_image"
    t.datetime "birthday"
    t.integer  "country_id"
    t.string   "state_city"
    t.string   "street"
    t.string   "website",                  limit: 1024
    t.string   "google_plus",              limit: 1024
    t.string   "facebook",                 limit: 1024
    t.string   "twitter",                  limit: 1024
    t.integer  "lock_version"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "deleted_at"
    t.integer  "birthday_access_scope_id",               null: false
    t.index ["birthday_access_scope_id"], name: "index_profiles_on_birthday_access_scope_id", using: :btree
    t.index ["deleted_at"], name: "index_profiles_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true, using: :btree
  end

  create_table "tags", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name",       limit: 64, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_tags_on_deleted_at", using: :btree
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "third_party_access_tokens", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.bigint   "user_id",                  null: false
    t.string   "uid",                      null: false
    t.string   "provider",      limit: 32, null: false
    t.string   "token",                    null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_third_party_access_tokens_on_user_id", using: :btree
  end

  create_table "users", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name",                   limit: 128,              null: false
    t.string   "email",                              default: "", null: false
    t.string   "password_digest"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.datetime "locked_at"
    t.integer  "lock_version",                       default: 0,  null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.datetime "deleted_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "followings", "users"
  add_foreign_key "followings", "users", column: "owner_id"
  add_foreign_key "profiles", "access_scopes", column: "birthday_access_scope_id"
  add_foreign_key "third_party_access_tokens", "users"
end
