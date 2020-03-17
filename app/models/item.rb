class Item < ApplicationRecord
  validates :code, :weight, :bucket_id, presence: true
  
  belongs_to :sub_category
  belongs_to :gold_type
  belongs_to :store
  belongs_to :bucket
end

