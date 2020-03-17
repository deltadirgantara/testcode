class Store < ApplicationRecord
  validates :name, :address, :phone, presence: true
  has_many :users
  has_many :items
  has_many :customers
  has_many :custom_orders
end

