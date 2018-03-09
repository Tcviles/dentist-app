class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :title
      t.text :content
      t.integer :dentist_id
      t.integer :user_id
    end
  end
end
