class CashFlow < ApplicationRecord
  validates :type_cash, :type_flow, :ref_id, presence: true
  
  enum type_flow: { 
    IN: 1,
    OUT: 2
  }

  enum type_cash: {
    Pajak: 1,
    Operasional: 2,
    Biaya_Pasti: 3,
    Modal: 4,
    Pengeluaran_Lainnya: 5
  }

  TAX = 'Pajak'
  MODAL = 'Modal'
  OPERATIONAL= 'Operasional'
  FIX_COST = 'Biaya_Pasti'
  OUTCOME = 'Pengeluaran_Lainnya'

end
