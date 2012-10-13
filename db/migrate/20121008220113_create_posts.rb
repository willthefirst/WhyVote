class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :candidate
      t.text :reason
      t.string :email

      t.timestamps
    end
  end
end
