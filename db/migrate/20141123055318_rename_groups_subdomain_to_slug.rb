class RenameGroupsSubdomainToSlug < ActiveRecord::Migration
  def change
  	rename_column :groups, :subdomain, :slug
  end
end
