class Trx < ApplicationRecord
	validates :store_id , :user_id, :nominal, :n_item, :payment_type, :invoice, presence: true

	belongs_to :store
	belongs_to :user
	belongs_to :bank, optional: true
	belongs_to :customer, optional: true
	has_many :trx_items
	enum payment_type:{
		CASH: 1,
		DEBIT: 2,
		CREDIT: 3
	}
end