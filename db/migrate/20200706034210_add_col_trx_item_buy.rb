class AddColTrxItemBuy < ActiveRecord::Migration[5.2]
  def change
  	add_reference :trx_buy_items, :gold_type, foreign_key: true
  end
end
