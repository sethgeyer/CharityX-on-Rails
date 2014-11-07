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

ActiveRecord::Schema.define(version: 20141107213347) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charities", force: true do |t|
    t.string   "name"
    t.integer  "tax_id"
    t.string   "poc"
    t.string   "poc_email"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chips", force: true do |t|
    t.integer  "owner_id"
    t.string   "status"
    t.string   "l1_tag_id"
    t.string   "l2_tag_id"
    t.integer  "charity_id"
    t.date     "purchase_date"
    t.date     "cashed_in_date"
    t.boolean  "wagerable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "deposits", force: true do |t|
    t.integer  "amount"
    t.integer  "cc_number"
    t.date     "exp_date"
    t.string   "name_on_card"
    t.string   "cc_type"
    t.date     "date_created"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "distributions", force: true do |t|
    t.integer  "amount"
    t.integer  "charity_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "non_registered_wagerees", force: true do |t|
    t.string  "email"
    t.integer "wager_id"
  end

  create_table "password_resets", force: true do |t|
    t.string "email"
    t.string "unique_identifier"
    t.date   "expiration_date"
  end

  create_table "sports_games", force: true do |t|
    t.string   "uuid"
    t.datetime "date"
    t.integer  "week"
    t.string   "home_id"
    t.string   "vs_id"
    t.string   "status"
    t.string   "venue"
    t.string   "temperature"
    t.string   "condition"
    t.string   "full_home_name"
    t.string   "full_visitor_name"
  end

  create_table "sports_games_outcomes", force: true do |t|
    t.string  "game_uuid"
    t.string  "home_id"
    t.integer "home_score"
    t.string  "vs_id"
    t.integer "vs_score"
    t.string  "status"
    t.integer "quarter"
    t.string  "clock"
    t.integer "week"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.boolean  "is_admin",        default: false
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "timezone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "wager_view_preferences", force: true do |t|
    t.integer "wager_id"
    t.integer "user_id"
    t.boolean "show"
  end

  create_table "wagers", force: true do |t|
    t.string   "title"
    t.datetime "date_of_wager"
    t.string   "details"
    t.integer  "amount"
    t.integer  "wageree_id"
    t.string   "status"
    t.string   "wagerer_outcome"
    t.string   "wageree_outcome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_id"
    t.integer  "user_id"
    t.string   "game_id"
    t.string   "selected_winner_id"
    t.string   "wager_type"
    t.integer  "game_week"
    t.string   "home_id"
    t.string   "vs_id"
    t.string   "game_uuid"
  end

end
