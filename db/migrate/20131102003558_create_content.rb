class CreateContent < ActiveRecord::Migration
  def change
    create_table :content do |t|
      t.integer :draw_id
      t.integer :user_id
      t.string :title
      t.text :body

      t.timestamps
    end
    add_index :content, :draw_id
    add_index :content, :user_id
  end
end
