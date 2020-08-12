class AddColumnItem < ActiveRecord::Migration[5.2]
  def change
  	add_reference :gold_types, :gold_master, foreign_key: true
    add_column :items, :name, :string, null: false, default: "-"
  end
end
