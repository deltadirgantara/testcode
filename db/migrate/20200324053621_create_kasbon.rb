class CreateKasbon < ActiveRecord::Migration[5.2]
  def change
    create_table :kasbons do |t|
        t.string :invoice, null: false
    	t.references :user, null: false, foreign_key: true
    	t.references :store, null: false, foreign_key: true
    	t.bigint :nominal, null: false
    	t.bigint :deficiency, null: false
    	t.timestamp :date_complete
    	t.integer :type_kasbon, null: false
		t.integer :target, null: false
        t.string :description
      
    	t.timestamps 
    end
  end
end
