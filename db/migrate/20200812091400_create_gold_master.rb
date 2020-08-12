class CreateGoldMaster < ActiveRecord::Migration[5.2]
  def change
    create_table :gold_masters do |t|
    	t.string :name, null: false
    	t.timestamps
    end

  end
end
