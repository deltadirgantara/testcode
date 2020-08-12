class ServiceItem < ApplicationRecord
  validates :item_id, :service_id, presence: true
  
  belongs_to :item
  belongs_to :service
end