class CreateService < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
    	t.references :store, null: false, foreign_key: true
    	t.references :user, null: false, foreign_key: true
    	t.references :supplier, null: false, foreign_key: true
    	t.timestamp :done
    	t.bigint :cost, null: false
    	t.timestamps
    end
  end
end
