class Supplier < ApplicationRecord
  validates :name, :phone, :address, presence: true

  has_many :custom_orders
  
end

