class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :pool_id
      t.string :token
      t.string :name
      t.string :provider
      t.string :uid
      t.string :email
      t.string :location
      t.string :url
      t.string :image
      t.integer :role
      t.boolean :available

      t.timestamps
    end
    add_index :users, [:provider, :uid]
    add_index :users, :pool_id
  end
end
