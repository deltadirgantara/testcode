class CreateCustomOrder < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_orders do |t|
        t.string :invoice, null: false

    	t.references :store, foreign_key: true, null: false
    	t.references :user, foreign_key: true, null: false
    	t.references :customer, foreign_key: true, null: false
    	t.references :supplier, foreign_key: true

    	t.integer :estimate_work, null: false, default: 2

    	t.bigint :down_payment, null: false
    	t.bigint :service_cost, null: false, default: 0
    	t.bigint :total_payment, null: false, default: 0

    	t.timestamp :date_process
    	t.timestamp :date_receive

    	t.timestamps
    end
  end
end
