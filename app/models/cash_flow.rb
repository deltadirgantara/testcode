class CashFlow < ApplicationRecord
  validates :type_cash, :type_flow, :ref_id, presence: true
  
  enum type_flow: { 
    IN: 1,
    OUT: 2
  }

  enum type_cash: {
    Pajak: 1,
    Operasional: 2,
    Biaya_Pasti: 3
  }

  TAX = 'Pajak'
  OPERATIONAL= 'Operasional'
  FIX_COST = 'Biaya_Pasti'

end
