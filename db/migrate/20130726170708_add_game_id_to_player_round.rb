class AddGameIdToPlayerRound < ActiveRecord::Migration
  def change
    change_table :player_rounds do |t|
      t.integer :game_id
    end
  end
end
