class CreateTrxBuy < ActiveRecord::Migration[5.2]
  def change
    create_table :trx_buys do |t|
    	t.timestamp :date, null: false
    	t.references :store, foreign_key: true, null: false
    	t.references :user, foreign_key: true, null: false
    	t.references :customer, foreign_key: true 
    	t.bigint :nominal, null: false
    	t.string :invoice , null: false
    	t.integer :n_item, null: false
    	t.timestamps
    end
  end
end
