require 'rails_helper'

describe GuessesController do
  let (:game) { Game.new(
    id: 5,
    player_name: 'OW',
    game_result: 'In progress',
    secret_word: 'TURTLE'
  ) }

  let (:guesses) { [] }

  before do
    guesses.each do | guess |
      Guess.create(value: guess, game: game)
    end
  end

  describe '#create' do
    context 'when a guess was made' do
      let (:guesses) { ['T', 'A'] }
      it 'runs guess_service' do
        expect(game.reload.game_result).to eq 'In progress'

        guess_service = instance_double(GuessService)
        guess_params = { value: 'P' }
        expect(GuessService).to receive(:new).with(game, guess_params).and_return(guess_service)
        expect(guess_service).to receive(:call).and_return('Guess was successfully created.')


        post game_guesses_path(game), params: { guess: { value: 'P' } }
        expect(response).to redirect_to game
        expect(flash[:notice]).to eq 'Guess was successfully created.'
      end
    end
  end
end
