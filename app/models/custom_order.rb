class CustomOrder < ApplicationRecord
  # validates :name, presence: true
  
  has_many :custom_order_items
  belongs_to :store
  belongs_to :user
  belongs_to :supplier
  belongs_to :customer
end

