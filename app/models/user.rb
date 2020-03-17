class User < ApplicationRecord
  include Clearance::User
  validates :level, :email, :store_id, :password, presence: true
  validates_uniqueness_of :email
  enum level: { 
    owner: 1,
    super_admin: 2,
    super_visi: 3,
    staff: 4
  }

  enum sex: {
    laki_laki: 0,
    perempuan: 1
  }

  OWNER = 'owner'
  SUPERADMIN = 'super_admin'
  SUPERVISI = 'super_visi'
  STAFF = 'staff'

  belongs_to :store
  has_many :customers
  has_many :custom_orders
end
