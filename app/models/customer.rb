class Customer < ApplicationRecord
  validates :phone, :email, :user_id, :address, presence: true
  validates_uniqueness_of :phone
  
  belongs_to :user
  has_many :custom_orders
end
