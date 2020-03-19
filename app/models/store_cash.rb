class StoreCash < ApplicationRecord
	validates :store_id, :cash, :modal, presence: true

	belongs_to :store
end