class WashItem < ApplicationRecord
  validates :item_id, :wash_id, presence: true
  
  belongs_to :item
  belongs_to :wash
end