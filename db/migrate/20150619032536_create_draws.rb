class CreateDraws < ActiveRecord::Migration
  def change
    create_table :draws do |t|
      t.references :event, index: true
      t.references :group, index: true

      t.timestamps null: false
    end
    add_foreign_key :draws, :events
    add_foreign_key :draws, :groups
  end
end
