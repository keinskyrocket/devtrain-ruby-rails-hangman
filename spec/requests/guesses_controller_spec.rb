require 'rails_helper'

describe GuessesController do
  describe '#create' do
    context 'when the same guess was made' do
      it 'should display a message that the guess is dupe' do
        game = Game.create(
          id: 5,
          player_name: 'OW',
          game_result: 'In progress',
          secret_word: 'TURTLE'
        )
        
        guessed = [
          Guess.create(value: 'T', game: game), # Correct letter
          Guess.create(value: 'A', game: game),
        ]

        expect(game.reload.game_result).to eq 'In progress'
        post game_guesses_path(game), params: { guess: { value: 'A' } }
        expect(response).to redirect_to game

        expect(flash[:notice]).to eq 'The same guess is already made.'
      end
    end

    context 'when the guess loses the game' do
      it 'should display a message that game is over' do
        game = Game.create(
          id: 5,
          player_name: 'OW',
          game_result: 'In progress',
          secret_word: 'TURTLE'
        )
        
        guessed = [
          Guess.create(value: 'T', game: game), # Correct letter
          Guess.create(value: 'A', game: game),
          Guess.create(value: 'S', game: game),
          Guess.create(value: 'D', game: game),
          Guess.create(value: 'F', game: game),
          Guess.create(value: 'G', game: game),
          Guess.create(value: 'H', game: game),
          Guess.create(value: 'J', game: game),
          Guess.create(value: 'K', game: game)
        ]

        expect(game.reload.game_result).to eq 'In progress'
        post game_guesses_path(game), params: { guess: { value: 'Z' } }
        expect(response).to redirect_to game

        expect(game.reload.game_result).to eq 'Lose'
        expect(flash[:notice]).to eq 'Game is already over.'
      end

      it 'should set game_result to be Lose' do
        game = Game.create(
          id: 5,
          player_name: 'OW',
          game_result: 'In progress',
          secret_word: 'TURTLE'
        )
        
        guessed = [
          Guess.create(value: 'T', game: game), # Correct letter
          Guess.create(value: 'A', game: game),
          Guess.create(value: 'S', game: game),
          Guess.create(value: 'D', game: game),
          Guess.create(value: 'F', game: game),
          Guess.create(value: 'G', game: game),
          Guess.create(value: 'H', game: game),
          Guess.create(value: 'J', game: game),
          Guess.create(value: 'K', game: game)
        ]

        expect(game.reload.game_result).to eq 'In progress'
        post game_guesses_path(game), params: { guess: { value: 'Z' } }
        expect(response).to redirect_to game
    
        expect(game.reload.game_result).to eq 'Lose'
        expect(game.remaining_lives).to be 0
      end 
    end

    context 'when game is win' do
      it 'should set game_result to be Win' do
        game = Game.create(
          id: 11,
          player_name: 'OW',
          game_result: 'In progress',
          secret_word: 'TURTLE'
        )
        
        guessed = [
          Guess.create(value: 'T', game: game), # Correct letter
          Guess.create(value: 'U', game: game), # Correct letter
          Guess.create(value: 'R', game: game), # Correct letter
          Guess.create(value: 'L', game: game), # Correct letter
          Guess.create(value: 'F', game: game),
          Guess.create(value: 'G', game: game),
          Guess.create(value: 'H', game: game)
        ]

        expect(game.reload.game_result).to eq 'In progress'
        post game_guesses_path(game), params: { guess: { value: 'E' } }
        expect(response).to redirect_to game
        
        expect(game.reload.game_result).to eq 'Win'
        expect(game.remaining_lives).not_to be 0
      end
    end
  end
end
