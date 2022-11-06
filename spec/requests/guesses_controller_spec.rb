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
        allow(GuessService).to receive(:new).and_return(guess_service)
        allow(guess_service).to receive(:call).and_return('Guess was successfully created.')

        post game_guesses_path(game), params: { guess: { value: 'P' } }
        expect(response).to redirect_to game
        expect(flash[:notice]).to eq 'Guess was successfully created.'
      end
    end

    context 'when the same guess was made' do
      let (:guesses) { ['T', 'A'] }

      it 'should display a message that the guess is dupe' do
        expect(game.reload.game_result).to eq 'In progress'
        post game_guesses_path(game), params: { guess: { value: 'A' } }
        expect(response).to redirect_to game

        expect(flash[:notice]).to eq 'The same guess is already made.'
      end
    end

    context 'when the guess loses the game' do
      let (:guesses) { ['T', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K'] }

      it 'should display a message that game is over' do
        expect(game.reload.game_result).to eq 'In progress'
        post game_guesses_path(game), params: { guess: { value: 'Z' } }
        expect(response).to redirect_to game

        expect(game.reload.game_result).to eq 'Lose'
        expect(flash[:notice]).to eq 'Game over...'
      end

      it 'should set game_result to be Lose' do
        expect(game.reload.game_result).to eq 'In progress'
        post game_guesses_path(game), params: { guess: { value: 'Z' } }
        expect(response).to redirect_to game
    
        expect(game.reload.game_result).to eq 'Lose'
        expect(game.remaining_lives).to be 0
      end
    end

    context 'when game is win' do
      let (:guesses) { ['T', 'U', 'R', 'L', 'F', 'G', 'H'] }

      it 'should set game_result to be Win' do
        expect(game.reload.game_result).to eq 'In progress'
        post game_guesses_path(game), params: { guess: { value: 'E' } }
        expect(response).to redirect_to game
        
        expect(game.reload.game_result).to eq 'Win'
        expect(game.remaining_lives).not_to be 0
        expect(flash[:notice]).to eq 'You won!'
      end
    end
  end
end
