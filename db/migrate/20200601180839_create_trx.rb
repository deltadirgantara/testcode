class CreateTrx < ActiveRecord::Migration[5.2]
  def change
    create_table :trxes do |t|
    	t.timestamp :date, null: false
    	t.references :store, foreign_key: true, null: false
    	t.references :user, foreign_key: true, null: false
    	t.references :bank, foreign_key: true
    	t.references :customer, foreign_key: true 
    	t.bigint :nominal, null: false
    	t.string :invoice , null: false
    	t.integer :n_item, null: false
    	t.integer :payment_type, default: 1, null: false
    	t.bigint :edc_inv, default: 0
        t.bigint :card_number, default: 0
    	t.timestamps
    end
  end
end
