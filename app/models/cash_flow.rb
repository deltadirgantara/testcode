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
    Bank: 5,
    Pengeluaran_Lainnya: 6,
    Pemasukkan_Lainnya:7
  }

  TAX = 'Pajak'
  MODAL = 'Modal'
  OPERATIONAL= 'Operasional'
  FIX_COST = 'Biaya_Pasti'
  BANK = 'Bank'
  OTHEROUTCOME = 'Pengeluaran_Lainnya'
  OTHERINCOME = 'Pemasukkan_Lainnya'

end
