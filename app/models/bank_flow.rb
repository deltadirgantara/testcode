class BankFlow < ApplicationRecord
  validates :bank_id, :type_flow, :nominal, :store_id, :user_id, :invoice, presence: true
  
  enum type_flow: { 
    IN: 1,
    OUT: 2,
    TRANSFER: 3
  }

  enum type_in_out: {
  	Setor_Tunai: 1,
  	Bunga: 2,
  	Tarik_Tunai: 3,
  	Biaya_Admin: 4,
  	Biaya_Transfer: 5, 
  	Pajak_Bunga: 6
  }

  belongs_to :user
  belongs_to :store
  belongs_to :bank
end
