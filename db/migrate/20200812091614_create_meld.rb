class CreateMeld < ActiveRecord::Migration[5.2]
  def change
    create_table :melts do |t|
    	t.references :store, null: false, foreign_key: true
    	t.references :user, null: false, foreign_key: true
    	t.references :supplier, null: false, foreign_key: true
    	t.timestamp :done
    	t.bigint :cost, null: false, default: 0
    	t.bigint :receive, null: false, default: 0
    	t.references :gold_type, foreign_key: true, null:false
    	t.timestamps
    end
  end
end
