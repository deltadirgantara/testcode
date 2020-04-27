class AddColBankTypeInOut < ActiveRecord::Migration[5.2]
  def change
  	add_column :bank_flows, :type_in_out, :integer
  end
end
