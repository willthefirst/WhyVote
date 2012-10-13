class AddPostToUser < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :post_id, :integer
  end
end
