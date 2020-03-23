class BankFlow < ApplicationRecord
  validates :bank_id, :type_flow, :nominal, :store_id, :user_id, :invoice, presence: true
  
  enum type_flow: { 
    IN: 1,
    OUT: 2
  }

  belongs_to :user
  belongs_to :store
  belongs_to :bank
end
