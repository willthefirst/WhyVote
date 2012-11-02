class RemoveEmailFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :email
  end

  def down
    add_column :posts, :email, :string
  end
end
