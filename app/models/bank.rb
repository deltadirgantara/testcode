class Bank < ApplicationRecord
  validates :name, presence: true

  has_many :bank_flows
  has_many :store_banks
end

