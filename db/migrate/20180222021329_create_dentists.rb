class CreateDentists < ActiveRecord::Migration
  def change
    create_table :dentists do |t|
      t.text :name
      t.integer :fee
    end
  end
end
