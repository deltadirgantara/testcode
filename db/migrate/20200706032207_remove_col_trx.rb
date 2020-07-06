class RemoveColTrx < ActiveRecord::Migration[5.2]
  def change
  	remove_column :trxes, :n_item
  	remove_column :trx_buys, :n_item
  	remove_column :trx_buy_items, :item_id
  	remove_column :trx_buy_items, :sell
  	
  	add_column :trx_buy_items, :weight, :bigint, null: false, default: 0
	add_column :trx_buy_items, :description, :string, null: false, default: "DEFAULT"
  	
  end
end
