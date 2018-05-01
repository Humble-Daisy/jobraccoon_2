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

ActiveRecord::Schema.define(version: 20171215183416) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_boards_on_user_id", using: :btree
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "swimlane_id"
    t.string   "company"
    t.string   "title"
    t.string   "logo"
    t.string   "location"
    t.string   "salary"
    t.string   "url"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.boolean  "demo"
    t.index ["swimlane_id"], name: "index_cards_on_swimlane_id", using: :btree
    t.index ["user_id"], name: "index_cards_on_user_id", using: :btree
  end

  create_table "global_configs", force: :cascade do |t|
    t.string   "app_name"
    t.string   "app_domain"
    t.string   "facebook_app_id"
    t.string   "twitter_app_id"
    t.string   "linkedin_app_id"
    t.boolean  "use_slack",               default: false
    t.string   "slack_team"
    t.string   "slack_icon_url"
    t.string   "slack_user"
    t.string   "technical_support_email"
    t.string   "technical_slack_channel"
    t.string   "feedback_support_email"
    t.string   "feedback_slack_channel"
    t.string   "default_email_address"
    t.string   "default_slack_channel"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "swimlanes", force: :cascade do |t|
    t.integer  "board_id"
    t.text     "name"
    t.integer  "position"
    t.text     "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_swimlanes_on_board_id", using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "due_date"
    t.datetime "email_reminder"
    t.string   "task_type"
    t.integer  "card_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "completed"
    t.string   "subline"
    t.integer  "user_id"
    t.index ["card_id"], name: "index_tasks_on_card_id", using: :btree
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.boolean  "admin",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "boards", "users"
  add_foreign_key "cards", "swimlanes"
  add_foreign_key "cards", "users"
  add_foreign_key "swimlanes", "boards"
  add_foreign_key "tasks", "cards"
  add_foreign_key "tasks", "users"
end
