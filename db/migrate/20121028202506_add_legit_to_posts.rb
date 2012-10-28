class AddLegitToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :legit, :boolean, default: true
  end
end
