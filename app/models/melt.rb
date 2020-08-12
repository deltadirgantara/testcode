class Melt < ApplicationRecord
  validates :store_id, :user_id, :supplier_id, :gold_type, presence: true
  
  belongs_to: store
  belongs_to: user
  belongs_to: supplier
end