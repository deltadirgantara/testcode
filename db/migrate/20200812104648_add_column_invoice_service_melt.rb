class AddColumnInvoiceServiceMelt < ActiveRecord::Migration[5.2]
  def change
  	add_column :melts, :invoice, :string, null: false
  	add_column :services, :invoice, :string, null: false
  end
end
