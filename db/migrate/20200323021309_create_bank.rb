class CreateBank < ActiveRecord::Migration[5.2]
  def change
    create_table :banks do |t|
    	t.string :name, null: false

    	t.timestamps
    end

    add_reference :store_banks, :bank, foreign_key: true
    add_reference :bank_flows, :bank, foreign_key: true
    remove_column :bank_flows, :type_bank
    remove_column :store_banks, :type_bank
  end
end
