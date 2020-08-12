class Item < ApplicationRecord
  validates :code, :weight, :bucket_id, presence: true
  
  belongs_to :sub_category
  belongs_to :gold_type
  belongs_to :store
  belongs_to :bucket
  has_many :trx_items
  has_many :service_items
  has_many :melt_items
end

