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

ActiveRecord::Schema.define(version: 20180422203028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.string   "name",                         null: false
    t.text     "description"
    t.boolean  "is_main",      default: false
    t.integer  "profile_id"
    t.integer  "photos_count", default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["profile_id"], name: "index_albums_on_profile_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.string   "text"
    t.integer  "profile_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "likes_count",      default: 0
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["profile_id"], name: "index_comments_on_profile_id", using: :btree
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations_profiles", force: :cascade do |t|
    t.integer "profile_id",      null: false
    t.integer "conversation_id", null: false
    t.index ["conversation_id", "profile_id"], name: "index_conversations_profiles_on_conversation_id_and_profile_id", using: :btree
    t.index ["profile_id", "conversation_id"], name: "index_conversations_profiles_on_profile_id_and_conversation_id", using: :btree
  end

  create_table "friend_requests", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "status",       default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["recipient_id", "status"], name: "index_friend_requests_on_recipient_id_and_status", using: :btree
    t.index ["recipient_id"], name: "index_friend_requests_on_recipient_id", using: :btree
    t.index ["sender_id", "recipient_id"], name: "index_friend_requests_on_sender_id_and_recipient_id", unique: true, using: :btree
    t.index ["sender_id", "status"], name: "index_friend_requests_on_sender_id_and_status", using: :btree
    t.index ["sender_id"], name: "index_friend_requests_on_sender_id", using: :btree
  end

  create_table "likes", force: :cascade do |t|
    t.integer "profile_id"
    t.string  "likeable_type"
    t.integer "likeable_id"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id", using: :btree
    t.index ["profile_id"], name: "index_likes_on_profile_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.text     "text"
    t.boolean  "is_read",         default: false
    t.integer  "sender_id"
    t.integer  "conversation_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
    t.index ["sender_id"], name: "index_messages_on_sender_id", using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.string   "image"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "album_id"
    t.integer  "comments_count", default: 0
    t.integer  "likes_count",    default: 0
    t.text     "description"
    t.index ["album_id"], name: "index_photos_on_album_id", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "date_of_birth"
    t.integer  "gender"
    t.integer  "avatar_id"
    t.index ["avatar_id"], name: "index_profiles_on_avatar_id", using: :btree
    t.index ["first_name"], name: "index_profiles_on_first_name", using: :btree
    t.index ["gender"], name: "index_profiles_on_gender", using: :btree
    t.index ["last_name"], name: "index_profiles_on_last_name", using: :btree
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true, using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string  "taggable_type"
    t.integer "taggable_id"
    t.index ["tag_id", "taggable_id", "taggable_type"], name: "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "text",           limit: 20,             null: false
    t.integer  "taggings_count",            default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["text"], name: "index_tags_on_text", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "last_seen"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "albums", "profiles", on_delete: :cascade
  add_foreign_key "comments", "profiles", on_delete: :cascade
  add_foreign_key "conversations_profiles", "conversations", on_delete: :cascade
  add_foreign_key "conversations_profiles", "profiles", on_delete: :cascade
  add_foreign_key "friend_requests", "profiles", column: "recipient_id", on_delete: :cascade
  add_foreign_key "friend_requests", "profiles", column: "sender_id", on_delete: :cascade
  add_foreign_key "likes", "profiles"
  add_foreign_key "messages", "conversations", on_delete: :cascade
  add_foreign_key "messages", "profiles", column: "sender_id"
  add_foreign_key "photos", "albums", on_delete: :cascade
  add_foreign_key "profiles", "photos", column: "avatar_id", on_delete: :nullify
  add_foreign_key "profiles", "users"
  add_foreign_key "taggings", "tags", on_delete: :cascade
end
