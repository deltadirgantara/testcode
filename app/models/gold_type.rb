class GoldType < ApplicationRecord
  validates :name, presence: true
  
  has_many :items
  has_one :gold_price
  has_many :melts
end

