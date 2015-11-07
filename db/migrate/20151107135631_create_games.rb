class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :player_email, null: false
      t.integer :game_time, null: false
      t.integer :quiz_health, null: false
      t.integer :player_health, null: false
      t.references :quiz, index: true

      t.timestamps null: false
    end
  end
end
