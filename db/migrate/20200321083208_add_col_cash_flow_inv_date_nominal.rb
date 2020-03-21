class AddColCashFlowInvDateNominal < ActiveRecord::Migration[5.2]
  def change
  	add_column :cash_flows, :nominal, :float
  	add_column :cash_flows, :date, :timestamp
  end
end
