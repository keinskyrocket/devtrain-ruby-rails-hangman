require 'rails_helper'

describe GamesController do
  context 'when creating a game' do
    let(:valid_params) { {
      player_name: 'OW',
      game_result: 'In progress',
      secret_word: 'TURTLE',
    } }

    it 'creates a new game with correct defaults and a secret word' do     
      game_builder = instance_double(GameBuilder)
      allow(GameBuilder).to receive(:new).and_return(game_builder)
      expect(game_builder).to receive(:call).and_return(Game.new(valid_params))
      
      expect{
        post games_path, params: { game: valid_params }
      }.to change{Game.count}.by(1)
      
      expect(response).to redirect_to(game_path(Game.last[:id]))
      expect(flash[:notice]).to eq 'Game was successfully created.'
      
      game = Game.last
      expect(game.remaining_lives).to be 9
      expect(game.reload.game_result).to eq 'In progress'
      expect(game.secret_word).to eq 'TURTLE'
      expect(game.player_name).to eq 'OW'

    end
  end

  context 'when "Destroy this game" button is pressed' do
    before(:each) do
      @game = Game.create(
        id: 5,
        player_name: 'OW',
        game_result: 'In progress',
        secret_word: 'TURTLE'
      )
    end

    it 'destroys the game' do
      expect{
        delete game_path(@game.id)
      }.to change{Game.count}.by(-1)

      expect(response).to redirect_to(games_path)
      expect(flash[:notice]).to eq 'Game was successfully destroyed.'
    end
  end
end
