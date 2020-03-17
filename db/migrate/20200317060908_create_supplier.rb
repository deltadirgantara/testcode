class CreateSupplier < ActiveRecord::Migration[5.2]
  def change
    create_table :suppliers do |t|
    	t.string :name, null: false
    	t.bigint :phone, null: false, default: 0
    	t.string :address, null: false, default: "-"
    	t.timestamps
    end
  end
end
