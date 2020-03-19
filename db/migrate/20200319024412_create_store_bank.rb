class CreateStoreBank < ActiveRecord::Migration[5.2]
  def change
    create_table :store_banks do |t|
    	t.timestamp :date, null: false
    	t.references :store, foreign_key: true, null: false
    	t.integer :type_bank, null: false
    	t.bigint :nominal, null: false
        
    	t.timestamps
    end
  end
end
