class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :name
      t.text :email
      t.text :password_digest
      t.integer :insurance_id
      t.integer :dentist_id
    end
  end
end
