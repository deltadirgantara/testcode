class Item < ApplicationRecord
  validates :code, :weight, :bucket_id, presence: true
  
  belongs_to :sub_category
  belongs_to :gold_type
  belongs_to :store
  belongs_to :bucket
  has_many :trx_items
  has_many :service_items
  has_many :melt_items
  has_many :wash_items

  enum status: {
  	TERJUAL: -1, 
    TERSEDIA: 0,
    CUCI: 1,
    SERVICE: 2,
    LEBUR: 3
  }
end

