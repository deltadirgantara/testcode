class OtherOutcome < ApplicationRecord
	validates :store_id , :user_id, :nominal, :invoice, presence: true

	belongs_to :store
	belongs_to :user
end