class AddColItemBucketId < ActiveRecord::Migration[5.2]
  def change
  	add_reference :items, :bucket, foreign_key: true
  	add_column :items, :buy, :float, null: false, default: 0
  end
end
