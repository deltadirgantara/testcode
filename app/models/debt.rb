class Debt < ApplicationRecord
  validates :nominal, :target, :store_id, :user_id, presence: true
  
  belongs_to :store
  belongs_to :user

  enum type_debt: {
  	BANK: 1
  }

  BANK = "BANK"
  
end
