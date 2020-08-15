class CreateWash < ActiveRecord::Migration[5.2]
  def change
    create_table :washes do |t|
    	t.references :store, null: false, foreign_key: true
    	t.references :user, null: false, foreign_key: true
    	t.timestamp :done
    	t.timestamps
    end
  end
end
