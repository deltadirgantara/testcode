class Service < ApplicationRecord
  validates :invoice, :store_id, :user_id, :supplier_id, presence: true
  
  belongs_to :store
  belongs_to :user
  belongs_to :supplier
end