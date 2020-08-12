class Melt < ApplicationRecord
  validates :invoice, :store_id, :user_id, :supplier_id, :gold_type_id, presence: true
  
  belongs_to :store
  belongs_to :user
  belongs_to :supplier
  belongs_to :gold_type
  has_many :melt_items
end