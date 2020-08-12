class GoldMaster < ApplicationRecord
  validates :name, presence: true
  
  has_one :gold_types
end