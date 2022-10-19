require 'rails_helper'

describe GuessesController do
  let (:game) { Game.new(
    id: 5,
    player_name: 'OW',
    game_result: 'In progress',
    secret_word: 'TURTLE'
  ) }

  describe '#create' do
    context 'when the same guess was made' do
      before do
        Guess.create(value: 'T', game: game) # Correct letter
        Guess.create(value: 'A', game: game)
      end

      it 'should display a message that the guess is dupe' do
        expect(game.reload.game_result).to eq 'In progress'
        post game_guesses_path(game), params: { guess: { value: 'A' } }
        expect(response).to redirect_to game

        expect(flash[:notice]).to eq 'The same guess is already made.'
      end
    end

    context 'when the guess loses the game' do
      before do
        Guess.create(value: 'T', game: game) # Correct letter
        Guess.create(value: 'A', game: game)
        Guess.create(value: 'S', game: game)
        Guess.create(value: 'D', game: game)
        Guess.create(value: 'F', game: game)
        Guess.create(value: 'G', game: game)
        Guess.create(value: 'H', game: game)
        Guess.create(value: 'J', game: game)
        Guess.create(value: 'K', game: game)
      end

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
      before do
        Guess.create(value: 'T', game: game) # Correct letter
        Guess.create(value: 'U', game: game) # Correct letter
        Guess.create(value: 'R', game: game) # Correct letter
        Guess.create(value: 'L', game: game) # Correct letter
        Guess.create(value: 'F', game: game)
        Guess.create(value: 'G', game: game)
        Guess.create(value: 'H', game: game)
      end

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
