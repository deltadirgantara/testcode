class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :name, null: false
      t.integer :level, null: false
      t.string :email, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.integer :level, null: false, default: 0
      t.string :phone, null: false, default: 62123456789
      t.string :address, null: false, default: "DEFAULT ADDRESS"
      t.integer :sex, null: false, default: 0
      t.bigint :id_card, null: false, default: 123456789123456
      t.bigint :salary, null: false, default: 0
      t.string :image
      t.integer :fingerprint
    end

    add_index :users, :email
    add_index :users, :remember_token
  end
end
