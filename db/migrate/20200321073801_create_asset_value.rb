class CreateAssetValue < ActiveRecord::Migration[5.2]
  def change
    create_table :asset_values do |t|
    	t.timestamp :date, null: false
    	t.references :store, foreign_key: true, null: false
    	t.bigint :nominal, null: false
    	t.string :invoice , null:false
        
    	t.timestamps
    end
  end
end
