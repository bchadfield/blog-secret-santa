class CreateDraws < ActiveRecord::Migration
  def change
    create_table :draws do |t|
      t.datetime :match_time
      t.datetime :gift_time
      t.string :status
      t.timestamps
    end
  end
end
