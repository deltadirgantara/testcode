class Modal < ApplicationRecord
	validates :store_id , :user_id, :nominal, :invoice, presence: true

	enum type_modal: { 
	    IN: 1,
	    OUT: 2
	  }

	belongs_to :store
	belongs_to :user
end