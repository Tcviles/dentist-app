class CreateInsurances < ActiveRecord::Migration
  def change
    create_table :insurances do |t|
      t.text :company
      t.integer :coverage
    end
  end
end
