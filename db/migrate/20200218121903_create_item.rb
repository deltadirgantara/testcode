class CreateItem < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
    	t.string :code, null: false
    	t.float :weight, null: false
    	t.integer :stock, null: false, default: 1
    	t.references :sub_category, null: false, foreign_key: true
    	t.references :gold_type, null: false, foreign_key: true
        t.references :store, null: false, foreign_key: true
    	t.string :image
    	t.timestamps
    end
  end
end
