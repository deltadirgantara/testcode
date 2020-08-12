class CreateMeldItem < ActiveRecord::Migration[5.2]
  def change
    create_table :melt_items do |t|
    	t.timestamps
    	t.references :melt, foreign_key: true, null: false
    	t.references :item, foreign_key: true, null: false
    	t.string :description
    end
  end
end
