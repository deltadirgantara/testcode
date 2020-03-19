class StoreCash < ApplicationRecord
	validates :store_id, :cash, :modal, presence: true

	# StoreCash.create modal: 100000000, cash: 100000000, store: Store.first, date: Date.today.beginning_of_month

	belongs_to :store
end