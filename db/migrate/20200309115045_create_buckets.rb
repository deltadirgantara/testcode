class CreateBuckets < ActiveRecord::Migration[5.2]
  def change
    create_table :buckets do |t|
    	t.string :name, null: false
    	t.float :weight, default: 0
    	t.timestamps
    end
  end
end
