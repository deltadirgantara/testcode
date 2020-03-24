class CreatePayment < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
        t.timestamp :date, null: false
        t.string :invoice, null: false
    	t.integer :nominal, null: false
    	t.references :store, null: false, foreign_key: true
    	t.references :user, null: false, foreign_key: true
    	t.integer :target, null: false
    	t.integer :type_payment, null: false
    	
    	t.timestamps
    end
  end
end
