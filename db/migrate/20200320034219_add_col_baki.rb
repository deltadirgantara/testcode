class AddColBaki < ActiveRecord::Migration[5.2]
  def change
  	add_reference :buckets, :store, foreign_key: true
  end
end
