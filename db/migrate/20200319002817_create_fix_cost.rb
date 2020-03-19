class CreateFixCost < ActiveRecord::Migration[5.2]
  def change
    create_table :fix_costs do |t|
    	t.timestamp :date, null: false
    	t.references :store, foreign_key: true, null: false
    	t.references :user, foreign_key: true, null: false
    	t.bigint :nominal, null: false
    	t.string :invoice , null:false
        t.string :description
        
    	t.timestamps
    end
  end
end
