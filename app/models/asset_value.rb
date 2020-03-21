class AssetValue < ApplicationRecord
	validates :store_id, :date, :nominal, :invoice, presence: true

	belongs_to :store
end