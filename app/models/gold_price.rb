class GoldPrice < ApplicationRecord
  validates :gold_type_id, :buy, :sell, presence: true

  belongs_to :gold_type
end

