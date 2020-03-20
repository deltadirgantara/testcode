class Store < ApplicationRecord
  validates :name, :address, :phone, presence: true
  has_many :users
  has_many :items
  has_many :customers
  has_many :custom_orders
  has_many :operationals
  has_many :taxs
  has_many :buckets
end

