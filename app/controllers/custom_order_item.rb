class CustomOrderItem < ApplicationRecord
  # validates :name, presence: true
  
  belongs_to :custom_order
end

