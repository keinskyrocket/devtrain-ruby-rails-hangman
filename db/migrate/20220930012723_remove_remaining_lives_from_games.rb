class RemoveRemainingLivesFromGames < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :remaining_lives, :integer
  end
end
