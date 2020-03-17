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

ActiveRecord::Schema.define(version: 2020_03_17_065119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "buckets", force: :cascade do |t|
    t.string "name", null: false
    t.float "weight", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_order_items", force: :cascade do |t|
    t.bigint "gold_type_id", null: false
    t.float "estimate_weight", null: false
    t.string "description", null: false
    t.integer "estimate_work", default: 2, null: false
    t.float "final_weight", default: 0.0, null: false
    t.bigint "total"
    t.bigint "service_cost", default: 0, null: false
    t.bigint "custom_order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_order_id"], name: "index_custom_order_items_on_custom_order_id"
    t.index ["gold_type_id"], name: "index_custom_order_items_on_gold_type_id"
  end

  create_table "custom_orders", force: :cascade do |t|
    t.string "invoice", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "customer_id", null: false
    t.bigint "supplier_id"
    t.integer "estimate_work", default: 2, null: false
    t.bigint "down_payment", null: false
    t.bigint "service_cost", default: 0, null: false
    t.bigint "total_payment", default: 0, null: false
    t.datetime "date_process"
    t.datetime "date_receive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_custom_orders_on_customer_id"
    t.index ["store_id"], name: "index_custom_orders_on_store_id"
    t.index ["supplier_id"], name: "index_custom_orders_on_supplier_id"
    t.index ["user_id"], name: "index_custom_orders_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.bigint "phone", null: false
    t.string "email", null: false
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "gold_prices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gold_type_id", null: false
    t.float "buy", null: false
    t.float "sell", null: false
    t.index ["gold_type_id"], name: "index_gold_prices_on_gold_type_id"
  end

  create_table "gold_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "code", null: false
    t.float "weight", null: false
    t.integer "stock", default: 1, null: false
    t.bigint "sub_category_id", null: false
    t.bigint "gold_type_id", null: false
    t.bigint "store_id", null: false
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bucket_id"
    t.float "buy", default: 0.0, null: false
    t.index ["bucket_id"], name: "index_items_on_bucket_id"
    t.index ["gold_type_id"], name: "index_items_on_gold_type_id"
    t.index ["store_id"], name: "index_items_on_store_id"
    t.index ["sub_category_id"], name: "index_items_on_sub_category_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "date_created", null: false
    t.integer "read", default: 0, null: false
    t.string "link", null: false
    t.string "message", null: false
    t.integer "m_type", default: 1, null: false
    t.bigint "from_user_id", null: false
    t.bigint "to_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_notifications_on_from_user_id"
    t.index ["to_user_id"], name: "index_notifications_on_to_user_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", default: "DEFAULT STORE NAME", null: false
    t.string "address", default: "DEFAULT STORE ADDRESS", null: false
    t.string "phone", default: "1234567", null: false
    t.integer "store_type", default: 1, null: false
    t.bigint "cash", default: 100000000, null: false
    t.bigint "equity", default: 100000000, null: false
    t.bigint "debt", default: 0, null: false
    t.bigint "receivable", default: 0, null: false
    t.bigint "bank", default: 0, null: false
    t.bigint "grand_total_before", default: 0, null: false
    t.bigint "modals_before", default: 0, null: false
    t.bigint "grand_total_card_before", default: 0, null: false
    t.bigint "store_balances", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "phone", default: 0, null: false
    t.string "address", default: "-", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "level", default: 0, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "phone", default: "62123456789", null: false
    t.string "address", default: "DEFAULT ADDRESS", null: false
    t.integer "sex", default: 0, null: false
    t.bigint "id_card", default: 123456789123456, null: false
    t.bigint "salary", default: 0, null: false
    t.string "image"
    t.integer "fingerprint"
    t.bigint "store_id", default: 1, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
    t.index ["store_id"], name: "index_users_on_store_id"
  end

  add_foreign_key "custom_order_items", "custom_orders"
  add_foreign_key "custom_order_items", "gold_types"
  add_foreign_key "custom_orders", "customers"
  add_foreign_key "custom_orders", "stores"
  add_foreign_key "custom_orders", "suppliers"
  add_foreign_key "custom_orders", "users"
  add_foreign_key "customers", "users"
  add_foreign_key "gold_prices", "gold_types"
  add_foreign_key "items", "buckets"
  add_foreign_key "items", "gold_types"
  add_foreign_key "items", "stores"
  add_foreign_key "items", "sub_categories"
  add_foreign_key "notifications", "users", column: "from_user_id"
  add_foreign_key "notifications", "users", column: "to_user_id"
  add_foreign_key "sub_categories", "categories"
end
