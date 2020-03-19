class StoreBank < ApplicationRecord
	validates :store_id, :nominal, :type_bank, :date, presence: true

	# StoreBank.create nominal: 100000000, store: Store.first, date: Date.today.beginning_of_month, type_bank: 1

	enum type_bank: {
	    BCA: 1,
	    MANDIRI: 2
	}

	BCA = "BCA"
	MANDIRI = "MANDIRI"
	
	belongs_to :store
end