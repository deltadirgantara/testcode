class Payment < ApplicationRecord
  validates :invoice, :nominal, :user_id, :store_id , presence: true
  
  belongs_to :store
  belongs_to :user

end
