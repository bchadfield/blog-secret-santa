class RenamePoolToGroup < ActiveRecord::Migration
  def change
  	rename_column :users, :pool_id, :group_id
  	rename_column :matches, :pool_id, :group_id
  	rename_column :content, :pool_id, :group_id
  	rename_table :pools, :groups
  end
end
