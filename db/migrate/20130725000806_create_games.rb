class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.integer :points
      t.string :status
      t.string :config
      
      t.timestamps
    end
  end
end
