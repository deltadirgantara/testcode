class Wash < ApplicationRecord
  validates :invoice, :store_id, :user_id, presence: true
  
  belongs_to :store
  belongs_to :user
  has_many :wash_items
end