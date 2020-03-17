class CreateGoldPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :gold_prices do |t|
    	t.timestamps
    	t.references :gold_type, foreign_key: true, null: false
    	t.float :buy, null: false
    	t.float :sell, null: false
    end
  end
end
