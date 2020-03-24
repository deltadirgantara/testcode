class AddRefStoreToCashFlow < ActiveRecord::Migration[5.2]
  def change
    add_reference :cash_flows, :store, foreign_key: true
  end
end
