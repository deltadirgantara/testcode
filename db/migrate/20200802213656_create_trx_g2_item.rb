class CreateTrxG2Item < ActiveRecord::Migration[5.2]
  def change
    create_table :trx_g2_items do |t|
    	t.references :item, foreign_key: true, null: false
    	t.references :trx, foreign_key: true, null:false
    	t.bigint :buy, null: false
    	t.bigint :sell, null: false
        
    	t.timestamps
    end
  end
end
