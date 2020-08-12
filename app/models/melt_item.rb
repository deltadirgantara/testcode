class MeltItem < ApplicationRecord
  validates :item_id, :melt_id, presence: true
  
  belongs_to :item
  belongs_to :melt
end