class AddColMember < ActiveRecord::Migration[5.2]
  def change
  	add_column :customers, :card_number, :bigint, null: false, default: 1
  end
end
