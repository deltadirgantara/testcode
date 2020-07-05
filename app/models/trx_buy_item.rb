class TrxBuyItem < ApplicationRecord
	validates :item_id , :trx_buy_id, :buy, :sell, presence: true

	belongs_to :item
	belongs_to :trx_buy
end