class AddNumberRoundsToGame < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :num_rounds
    end
  end
end
