class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :positive

      t.timestamps
    end
  end
end
