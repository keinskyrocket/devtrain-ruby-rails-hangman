class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :player_name
      t.string :game_result
      t.string :secret_word
      t.integer :remaining_lives

      t.timestamps
    end
  end
end
