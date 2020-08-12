class Store < ApplicationRecord
  validates :name, :address, :phone, presence: true
  has_many :users
  has_many :items
  has_many :customers
  has_many :custom_orders
  has_many :operationals
  has_many :taxs
  has_many :buckets
  has_many :asset_values
  has_many :melts
  has_many :services
end

