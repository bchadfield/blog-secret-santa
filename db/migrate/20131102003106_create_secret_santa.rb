class CreateSecretSanta < ActiveRecord::Migration
  def change
    create_table :secret_santa do |t|
      t.integer :draw_id
      t.integer :giver_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :secret_santa, :draw_id
    add_index :secret_santa, :giver_id
    add_index :secret_santa, :receiver_id
  end
end
