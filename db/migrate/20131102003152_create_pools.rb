class CreatePools < ActiveRecord::Migration
  def change
    create_table :pools do |t|
    	t.string :token
    	t.string :name
    	t.string :subdomain
      t.integer :status
      t.timestamps
    end
  end
end
