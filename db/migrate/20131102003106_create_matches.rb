class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :pool_id
      t.integer :giver_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :matches, :pool_id
    add_index :matches, :giver_id
    add_index :matches, :receiver_id
  end
end
