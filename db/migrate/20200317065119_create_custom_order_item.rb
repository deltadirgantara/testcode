class CreateCustomOrderItem < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_order_items do |t|
    	t.references :gold_type, null: false, foreign_key: true

    	t.float :estimate_weight, null: false

        t.string :description, null: false

        t.integer :estimate_work, null: false, default: 2
        
    	t.float :final_weight, null: false, default: 0
    	t.bigint :total
    	t.bigint :service_cost, null: false, default: 0

    	t.references :custom_order, foreign_key: true, null: false
    	
    	t.timestamps
    end
  end
end
