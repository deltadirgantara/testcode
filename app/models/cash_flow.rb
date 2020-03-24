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
    Pemasukkan_Lainnya:7,
    Pinjaman_Bank: 8,
    Bayar_Pinjaman_Bank: 9,
    Karyawan_Hutang: 10,
    Karyawan_Bayar_Hutang: 11,
    Kasbon: 12,
    Bayar_Kasbon: 13
  }

  belongs_to :store

  TAX = 'Pajak'
  MODAL = 'Modal'
  OPERATIONAL= 'Operasional'
  FIX_COST = 'Biaya_Pasti'
  BANK = 'Bank'
  OTHEROUTCOME = 'Pengeluaran_Lainnya'
  OTHERINCOME = 'Pemasukkan_Lainnya'
  BANK_LOAN = "Pinjaman_Bank"
  PAY_BANK_LOAN = "Bayar_Pinjaman_Bank"
  EMPLOYEE_LOAN = "Karyawan_Hutang"
  PAY_EMPLOYEE_LOAN = "Karyawan_Bayar_Hutang"
  KASBON = "Kasbon"
  PAY_KASBON = "Bayar_Kasbon"

end
