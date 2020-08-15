class AddColumnInvoiceWash < ActiveRecord::Migration[5.2]
  def change
  	add_column :washes, :invoice, :string, null: false
  end
end
