class AddPopularityToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :popularity, :float, default: 0
  end
end
