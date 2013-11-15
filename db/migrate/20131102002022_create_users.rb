class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :provider
      t.string :uid
      t.string :email
      t.string :location
      t.string :url
      t.string :image
      t.boolean :admin
      t.boolean :available

      t.timestamps
    end
    add_index :users, [:provider, :uid]
  end
end
