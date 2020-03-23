class StoreBank < ApplicationRecord
	validates :store_id, :nominal, :bank_id, :date, presence: true

	# StoreBank.create nominal: 100000000, store: Store.first, date: Date.today.beginning_of_month, type_bank: 1
	
	belongs_to :store
	belongs_to :bank
end