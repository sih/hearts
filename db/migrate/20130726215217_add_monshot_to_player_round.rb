class AddMonshotToPlayerRound < ActiveRecord::Migration
  def change
    change_table :player_rounds do |t|
      t.boolean :mon_shot
    end    
  end
end
