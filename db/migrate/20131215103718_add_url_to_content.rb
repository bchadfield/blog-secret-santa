class AddUrlToContent < ActiveRecord::Migration
  def change
    add_column :content, :url, :string
  end
end
