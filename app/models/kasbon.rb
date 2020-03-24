class Kasbon < ApplicationRecord
  validates :nominal, :target, :store_id, :user_id, presence: true
  
  belongs_to :store
  belongs_to :user
end



  