class AddDrawsToMatchesAndContent < ActiveRecord::Migration
  def change
  	add_column :matches, :draw_id, :integer, index: true
  	add_column :content, :draw_id, :integer, index: true
  	add_foreign_key :matches, :draws
    add_foreign_key :content, :draws
  end
end
