class CreateCustomer < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
    	t.references :user, foreign_key: true, null: false
    	t.string :name, null: false
    	t.bigint :phone, null: false
    	t.string :email, null: false
    	t.string :address, null: false
    	t.timestamps
    end
  end
end
