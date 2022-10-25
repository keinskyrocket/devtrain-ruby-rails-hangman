require 'rails_helper'

describe GamesController do
  context 'when "Create Game" button is pressed' do
    it 'creates a new game' do
      params = {
        id: 2,
        player_name: 'OW',
        game_result: 'In progress',
        secret_word: 'TURTLE'
      }

      get new_game_path
      expect(response).to be_successful

      post games_path, params: { game: params }
      expect(response).to redirect_to(game_path(Game.last))
      expect(flash[:notice]).to eq 'Game was successfully created.'
    end
  end

  context 'when "Destroy this game" button is pressed' do
    it 'destroys the game' do
      game = Game.create(
        id: 5,
        player_name: 'OW',
        game_result: 'In progress',
        secret_word: 'TURTLE'
      )

      get game_path(game.id)
      expect(response).to be_successful

      delete game_path(game.id)      
      expect(response).to redirect_to(games_path)
      expect(flash[:notice]).to eq 'Game was successfully destroyed.'
    end
  end
end