class CreateCashFlow < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_flows do |t|
    	t.bigint :ref_id, null: false
    	t.integer :type_cash, null: false
    	t.integer :type_flow, null: false
        
    	t.timestamps
    end
  end
end
