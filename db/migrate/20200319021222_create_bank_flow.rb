class CreateBankFlow < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_flows do |t|
    	t.integer :bank_id, null: false
    	t.bigint :nominal, null: false
    	t.integer :flow_type, null: false
    	t.references :store, null: false, foreign_key: true
    	t.references :user, null: false, foreign_key: true
    	t.string :invoice, null: false
    	t.timestamps
    end
  end
end
