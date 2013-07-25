class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :pass
      t.integer :position
      t.string :winner
      t.integer :game_id

      t.timestamps
    end
  end
end
