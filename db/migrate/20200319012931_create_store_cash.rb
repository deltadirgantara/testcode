class CreateStoreCash < ActiveRecord::Migration[5.2]
  def change
    create_table :store_cashes do |t|
    	t.timestamp :date, null: false
    	t.references :store, foreign_key: true, null: false
    	t.bigint :cash, null: false
    	t.bigint :modal, null: false
    	t.bigint :bank, null: false
        
    	t.timestamps
    end
  end
end
