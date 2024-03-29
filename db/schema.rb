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

ActiveRecord::Schema.define(version: 2020_08_15_162407) do

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

  create_table "asset_values", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_asset_values_on_store_id"
  end

  create_table "bank_flows", force: :cascade do |t|
    t.bigint "nominal", null: false
    t.integer "type_flow", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.string "invoice", null: false
    t.string "description"
    t.datetime "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bank_id"
    t.integer "type_in_out"
    t.index ["bank_id"], name: "index_bank_flows_on_bank_id"
    t.index ["store_id"], name: "index_bank_flows_on_store_id"
    t.index ["user_id"], name: "index_bank_flows_on_user_id"
  end

  create_table "banks", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buckets", force: :cascade do |t|
    t.string "name", null: false
    t.float "weight", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id"
    t.index ["store_id"], name: "index_buckets_on_store_id"
  end

  create_table "cash_flows", force: :cascade do |t|
    t.bigint "ref_id", null: false
    t.integer "type_cash", null: false
    t.integer "type_flow", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "nominal"
    t.datetime "date"
    t.bigint "store_id"
    t.index ["store_id"], name: "index_cash_flows_on_store_id"
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
    t.bigint "card_number", default: 1, null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "debts", force: :cascade do |t|
    t.datetime "due_date", null: false
    t.string "invoice", null: false
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.bigint "nominal", null: false
    t.bigint "deficiency", null: false
    t.datetime "date_complete"
    t.integer "type_debt", null: false
    t.integer "target", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_debts_on_store_id"
    t.index ["user_id"], name: "index_debts_on_user_id"
  end

  create_table "fix_costs", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_fix_costs_on_store_id"
    t.index ["user_id"], name: "index_fix_costs_on_user_id"
  end

  create_table "gold_masters", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "gold_master_id"
    t.index ["gold_master_id"], name: "index_gold_types_on_gold_master_id"
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
    t.string "name", default: "-", null: false
    t.integer "status", default: 0, null: false
    t.index ["bucket_id"], name: "index_items_on_bucket_id"
    t.index ["gold_type_id"], name: "index_items_on_gold_type_id"
    t.index ["store_id"], name: "index_items_on_store_id"
    t.index ["sub_category_id"], name: "index_items_on_sub_category_id"
  end

  create_table "kasbons", force: :cascade do |t|
    t.datetime "due_date", null: false
    t.string "invoice", null: false
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.bigint "nominal", null: false
    t.bigint "deficiency", null: false
    t.datetime "date_complete"
    t.integer "type_kasbon", null: false
    t.integer "target", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_kasbons_on_store_id"
    t.index ["user_id"], name: "index_kasbons_on_user_id"
  end

  create_table "melt_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "melt_id", null: false
    t.bigint "item_id", null: false
    t.string "description"
    t.index ["item_id"], name: "index_melt_items_on_item_id"
    t.index ["melt_id"], name: "index_melt_items_on_melt_id"
  end

  create_table "melts", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "supplier_id", null: false
    t.datetime "done"
    t.bigint "cost", default: 0, null: false
    t.float "receive", default: 0.0, null: false
    t.bigint "gold_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoice", null: false
    t.index ["gold_type_id"], name: "index_melts_on_gold_type_id"
    t.index ["store_id"], name: "index_melts_on_store_id"
    t.index ["supplier_id"], name: "index_melts_on_supplier_id"
    t.index ["user_id"], name: "index_melts_on_user_id"
  end

  create_table "modals", force: :cascade do |t|
    t.datetime "date", null: false
    t.integer "type_modal", default: 1, null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_modals_on_store_id"
    t.index ["user_id"], name: "index_modals_on_user_id"
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

  create_table "operationals", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_operationals_on_store_id"
    t.index ["user_id"], name: "index_operationals_on_user_id"
  end

  create_table "other_incomes", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_other_incomes_on_store_id"
    t.index ["user_id"], name: "index_other_incomes_on_user_id"
  end

  create_table "other_outcomes", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_other_outcomes_on_store_id"
    t.index ["user_id"], name: "index_other_outcomes_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "date", null: false
    t.string "invoice", null: false
    t.integer "nominal", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.integer "target", null: false
    t.integer "type_payment", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_payments_on_store_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "receivables", force: :cascade do |t|
    t.datetime "due_date", null: false
    t.string "invoice", null: false
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.bigint "nominal", null: false
    t.bigint "deficiency", null: false
    t.datetime "date_complete"
    t.integer "type_receivable", null: false
    t.integer "target", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_receivables_on_store_id"
    t.index ["user_id"], name: "index_receivables_on_user_id"
  end

  create_table "service_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_id", null: false
    t.bigint "item_id", null: false
    t.string "description"
    t.index ["item_id"], name: "index_service_items_on_item_id"
    t.index ["service_id"], name: "index_service_items_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "supplier_id", null: false
    t.datetime "done"
    t.bigint "cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoice", null: false
    t.index ["store_id"], name: "index_services_on_store_id"
    t.index ["supplier_id"], name: "index_services_on_supplier_id"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "store_banks", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "nominal", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bank_id"
    t.index ["bank_id"], name: "index_store_banks_on_bank_id"
    t.index ["store_id"], name: "index_store_banks_on_store_id"
  end

  create_table "store_cashes", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "cash", null: false
    t.bigint "modal", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_store_cashes_on_store_id"
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

  create_table "taxes", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_taxes_on_store_id"
    t.index ["user_id"], name: "index_taxes_on_user_id"
  end

  create_table "trx_buy_g1_items", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "trx_buy_id", null: false
    t.bigint "buy", null: false
    t.bigint "sell", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_trx_buy_g1_items_on_item_id"
    t.index ["trx_buy_id"], name: "index_trx_buy_g1_items_on_trx_buy_id"
  end

  create_table "trx_buy_g1s", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "customer_id"
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.integer "n_item", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_trx_buy_g1s_on_customer_id"
    t.index ["store_id"], name: "index_trx_buy_g1s_on_store_id"
    t.index ["user_id"], name: "index_trx_buy_g1s_on_user_id"
  end

  create_table "trx_buy_g2_items", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "trx_buy_id", null: false
    t.bigint "buy", null: false
    t.bigint "sell", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_trx_buy_g2_items_on_item_id"
    t.index ["trx_buy_id"], name: "index_trx_buy_g2_items_on_trx_buy_id"
  end

  create_table "trx_buy_g2s", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "customer_id"
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.integer "n_item", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_trx_buy_g2s_on_customer_id"
    t.index ["store_id"], name: "index_trx_buy_g2s_on_store_id"
    t.index ["user_id"], name: "index_trx_buy_g2s_on_user_id"
  end

  create_table "trx_buy_items", force: :cascade do |t|
    t.bigint "trx_buy_id", null: false
    t.bigint "buy", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "weight", default: 0, null: false
    t.string "description", default: "DEFAULT", null: false
    t.bigint "gold_type_id"
    t.index ["gold_type_id"], name: "index_trx_buy_items_on_gold_type_id"
    t.index ["trx_buy_id"], name: "index_trx_buy_items_on_trx_buy_id"
  end

  create_table "trx_buys", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "customer_id"
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_trx_buys_on_customer_id"
    t.index ["store_id"], name: "index_trx_buys_on_store_id"
    t.index ["user_id"], name: "index_trx_buys_on_user_id"
  end

  create_table "trx_g1_items", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "trx_id", null: false
    t.bigint "buy", null: false
    t.bigint "sell", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_trx_g1_items_on_item_id"
    t.index ["trx_id"], name: "index_trx_g1_items_on_trx_id"
  end

  create_table "trx_g1s", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "bank_id"
    t.bigint "customer_id"
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.integer "n_item", null: false
    t.integer "payment_type", default: 1, null: false
    t.bigint "edc_inv", default: 0
    t.bigint "card_number", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_id"], name: "index_trx_g1s_on_bank_id"
    t.index ["customer_id"], name: "index_trx_g1s_on_customer_id"
    t.index ["store_id"], name: "index_trx_g1s_on_store_id"
    t.index ["user_id"], name: "index_trx_g1s_on_user_id"
  end

  create_table "trx_g2_items", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "trx_id", null: false
    t.bigint "buy", null: false
    t.bigint "sell", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_trx_g2_items_on_item_id"
    t.index ["trx_id"], name: "index_trx_g2_items_on_trx_id"
  end

  create_table "trx_g2s", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "bank_id"
    t.bigint "customer_id"
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.integer "n_item", null: false
    t.integer "payment_type", default: 1, null: false
    t.bigint "edc_inv", default: 0
    t.bigint "card_number", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_id"], name: "index_trx_g2s_on_bank_id"
    t.index ["customer_id"], name: "index_trx_g2s_on_customer_id"
    t.index ["store_id"], name: "index_trx_g2s_on_store_id"
    t.index ["user_id"], name: "index_trx_g2s_on_user_id"
  end

  create_table "trx_items", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "trx_id", null: false
    t.bigint "buy", null: false
    t.bigint "sell", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_trx_items_on_item_id"
    t.index ["trx_id"], name: "index_trx_items_on_trx_id"
  end

  create_table "trxes", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "bank_id"
    t.bigint "customer_id"
    t.bigint "nominal", null: false
    t.string "invoice", null: false
    t.integer "payment_type", default: 1, null: false
    t.bigint "edc_inv", default: 0
    t.bigint "card_number", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_id"], name: "index_trxes_on_bank_id"
    t.index ["customer_id"], name: "index_trxes_on_customer_id"
    t.index ["store_id"], name: "index_trxes_on_store_id"
    t.index ["user_id"], name: "index_trxes_on_user_id"
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

  create_table "wash_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "wash_id", null: false
    t.bigint "item_id", null: false
    t.string "description"
    t.index ["item_id"], name: "index_wash_items_on_item_id"
    t.index ["wash_id"], name: "index_wash_items_on_wash_id"
  end

  create_table "washes", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.datetime "done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoice", null: false
    t.index ["store_id"], name: "index_washes_on_store_id"
    t.index ["user_id"], name: "index_washes_on_user_id"
  end

  add_foreign_key "asset_values", "stores"
  add_foreign_key "bank_flows", "banks"
  add_foreign_key "bank_flows", "stores"
  add_foreign_key "bank_flows", "users"
  add_foreign_key "buckets", "stores"
  add_foreign_key "cash_flows", "stores"
  add_foreign_key "custom_order_items", "custom_orders"
  add_foreign_key "custom_order_items", "gold_types"
  add_foreign_key "custom_orders", "customers"
  add_foreign_key "custom_orders", "stores"
  add_foreign_key "custom_orders", "suppliers"
  add_foreign_key "custom_orders", "users"
  add_foreign_key "customers", "users"
  add_foreign_key "debts", "stores"
  add_foreign_key "debts", "users"
  add_foreign_key "fix_costs", "stores"
  add_foreign_key "fix_costs", "users"
  add_foreign_key "gold_prices", "gold_types"
  add_foreign_key "gold_types", "gold_masters"
  add_foreign_key "items", "buckets"
  add_foreign_key "items", "gold_types"
  add_foreign_key "items", "stores"
  add_foreign_key "items", "sub_categories"
  add_foreign_key "kasbons", "stores"
  add_foreign_key "kasbons", "users"
  add_foreign_key "melt_items", "items"
  add_foreign_key "melt_items", "melts"
  add_foreign_key "melts", "gold_types"
  add_foreign_key "melts", "stores"
  add_foreign_key "melts", "suppliers"
  add_foreign_key "melts", "users"
  add_foreign_key "modals", "stores"
  add_foreign_key "modals", "users"
  add_foreign_key "notifications", "users", column: "from_user_id"
  add_foreign_key "notifications", "users", column: "to_user_id"
  add_foreign_key "operationals", "stores"
  add_foreign_key "operationals", "users"
  add_foreign_key "other_incomes", "stores"
  add_foreign_key "other_incomes", "users"
  add_foreign_key "other_outcomes", "stores"
  add_foreign_key "other_outcomes", "users"
  add_foreign_key "payments", "stores"
  add_foreign_key "payments", "users"
  add_foreign_key "receivables", "stores"
  add_foreign_key "receivables", "users"
  add_foreign_key "service_items", "items"
  add_foreign_key "service_items", "services"
  add_foreign_key "services", "stores"
  add_foreign_key "services", "suppliers"
  add_foreign_key "services", "users"
  add_foreign_key "store_banks", "banks"
  add_foreign_key "store_banks", "stores"
  add_foreign_key "store_cashes", "stores"
  add_foreign_key "sub_categories", "categories"
  add_foreign_key "taxes", "stores"
  add_foreign_key "taxes", "users"
  add_foreign_key "trx_buy_g1_items", "items"
  add_foreign_key "trx_buy_g1_items", "trx_buys"
  add_foreign_key "trx_buy_g1s", "customers"
  add_foreign_key "trx_buy_g1s", "stores"
  add_foreign_key "trx_buy_g1s", "users"
  add_foreign_key "trx_buy_g2_items", "items"
  add_foreign_key "trx_buy_g2_items", "trx_buys"
  add_foreign_key "trx_buy_g2s", "customers"
  add_foreign_key "trx_buy_g2s", "stores"
  add_foreign_key "trx_buy_g2s", "users"
  add_foreign_key "trx_buy_items", "gold_types"
  add_foreign_key "trx_buy_items", "trx_buys"
  add_foreign_key "trx_buys", "customers"
  add_foreign_key "trx_buys", "stores"
  add_foreign_key "trx_buys", "users"
  add_foreign_key "trx_g1_items", "items"
  add_foreign_key "trx_g1_items", "trxes"
  add_foreign_key "trx_g1s", "banks"
  add_foreign_key "trx_g1s", "customers"
  add_foreign_key "trx_g1s", "stores"
  add_foreign_key "trx_g1s", "users"
  add_foreign_key "trx_g2_items", "items"
  add_foreign_key "trx_g2_items", "trxes"
  add_foreign_key "trx_g2s", "banks"
  add_foreign_key "trx_g2s", "customers"
  add_foreign_key "trx_g2s", "stores"
  add_foreign_key "trx_g2s", "users"
  add_foreign_key "trx_items", "items"
  add_foreign_key "trx_items", "trxes"
  add_foreign_key "trxes", "banks"
  add_foreign_key "trxes", "customers"
  add_foreign_key "trxes", "stores"
  add_foreign_key "trxes", "users"
  add_foreign_key "wash_items", "items"
  add_foreign_key "wash_items", "washes"
  add_foreign_key "washes", "stores"
  add_foreign_key "washes", "users"
end
