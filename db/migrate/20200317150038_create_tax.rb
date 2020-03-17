class CreateTax < ActiveRecord::Migration[5.2]
  def change
    create_table :taxes do |t|
    	t.timestamp :date, null: false
    	t.references :store, foreign_key: true, null: false
    	t.references :user, foreign_key: true, null: false
    	t.bigint :nominal, null: false
    	t.timestamps
    end
  end
end
