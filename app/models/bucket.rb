class Bucket < ApplicationRecord
  validates :name, presence: true
  
  has_many :items
  belongs_to :store
end

