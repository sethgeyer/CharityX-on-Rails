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

ActiveRecord::Schema.define(version: 20140829180131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "amount"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "account_id"
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
  end

  create_table "deposits", force: true do |t|
    t.integer  "account_id"
    t.integer  "amount"
    t.integer  "cc_number"
    t.date     "exp_date"
    t.string   "name_on_card"
    t.string   "cc_type"
    t.date     "date_created"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distributions", force: true do |t|
    t.integer  "account_id"
    t.integer  "amount"
    t.integer  "charity_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mvps", force: true do |t|
    t.date     "date"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "non_registered_wagers", force: true do |t|
    t.string  "unique_id"
    t.string  "non_registered_user"
    t.integer "wager_id"
  end

  create_table "password_resets", force: true do |t|
    t.string "email"
    t.string "unique_identifier"
    t.date   "expiration_date"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "profile_picture"
    t.boolean  "is_admin",        default: false
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "wagers", force: true do |t|
    t.integer  "account_id"
    t.string   "title"
    t.date     "date_of_wager"
    t.string   "details"
    t.integer  "amount"
    t.integer  "wageree_id"
    t.string   "status"
    t.string   "wagerer_outcome"
    t.string   "wageree_outcome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_id"
  end

end
