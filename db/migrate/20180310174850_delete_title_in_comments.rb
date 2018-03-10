class DeleteTitleInComments < ActiveRecord::Migration
  def change
    remove_column :comments, :title
  end
end
