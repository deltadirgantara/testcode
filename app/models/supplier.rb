class Supplier < ApplicationRecord
  validates :name, :phone, :address, presence: true

  has_many :custom_orders
  has_many :melts
  has_many :services
  
end

