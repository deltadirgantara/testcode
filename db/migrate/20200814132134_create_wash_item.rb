class CreateWashItem < ActiveRecord::Migration[5.2]
  def change
    create_table :wash_items do |t|
    	t.timestamps
    	t.references :wash, foreign_key: true, null: false
    	t.references :item, foreign_key: true, null: false
    	t.string :description
    end
  end
end
