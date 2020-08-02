class TrxBuyG1Item < ApplicationRecord
	validates :description , :trx_buy_id, :buy, :description, :weight, presence: true

	belongs_to :trx_buy
	belongs_to :gold_type
	
end