class TrxG1Item < ApplicationRecord
	validates :item_id , :trx_id, :buy, :sell, presence: true

	belongs_to :item
	belongs_to :trx
end