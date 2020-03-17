class Operational < ApplicationRecord
  validates :nominal, :user_id, :store_id, :date , presence: true
  
  belongs_to :store
  belongs_to :user
  
end
