class AddStatusToContent < ActiveRecord::Migration
  def change
    add_column :content, :status, :string
  end
end
