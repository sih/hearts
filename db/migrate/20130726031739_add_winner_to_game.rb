class AddWinnerToGame < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.string :winner
    end
  end
end
