class CreateContent < ActiveRecord::Migration
  def change
    create_table :content do |t|
      t.integer :pool_id
      t.integer :match_id
      t.string :token
      t.string :title
      t.text :body
      t.string :url
      t.integer :status

      t.timestamps
    end
    add_index :content, :pool_id
    add_index :content, :match_id
  end
end
