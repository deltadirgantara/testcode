class BankFlow < ApplicationRecord
  validates :type_bank, :type_flow, :nominal, :store_id, :user_id, :invoice, presence: true
  
  enum type_flow: { 
    IN: 1,
    OUT: 2
  }

  enum type_bank: {
      BCA: 1,
      MANDIRI: 2
  }

  BCA = "BCA"
  MANDIRI = "MANDIRI"

  belongs_to :user
  belongs_to :store
end
