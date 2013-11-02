class CreateDraws < ActiveRecord::Migration
  def change
    create_table :draws do |t|
      t.datetime :draw_time
      t.string :status
      t.timestamps
    end
  end
end
