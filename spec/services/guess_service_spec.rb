require 'rails_helper'

describe GuessService do
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
  
  describe '#call' do
    context 'when a guess was made' do
      let (:guesses) { ['T'] }
      
      it 'display a message that the guess was successfully created' do
        expect(game.reload.game_result).to eq 'In progress'
                
        guess_service = GuessService.new(game, { value: 'A' })

        expect(guess_service.call).to eq 'Guess was successfully created.'
        expect(game.reload.game_result).to eq 'In progress'
        expect(game.guesses.last.value).to eq 'A'
      end
    end

    context 'when a guess was made after the game is over' do
      let (:guesses) { ['T', 'U', 'R', 'L'] }
      
      it 'display a message that the game is already over' do
        expect(game.reload.game_result).to eq 'In progress'
                
        guess_service1 = GuessService.new(game, { value: 'E' })
        guess_service1.call
        expect(game.reload.game_result).to eq 'Win'

        guess_service2 = GuessService.new(game, { value: 'P' })
        expect(guess_service2.call).to eq 'Game is already over.'
        expect(game.guesses.last.value).to eq 'P'
      end
    end

    context 'when the same guess was made' do
      let (:guesses) { ['T', 'U', 'R', 'L'] }
      
      it 'displays a message that the guess is dupe' do
        expect(game.reload.game_result).to eq 'In progress'

        initial_guesses = game.reload.guesses.count
        guess_service = GuessService.new(game, { value: 'L' })

        expect(game.guesses.count).to eq(initial_guesses)
        expect(guess_service.call).to eq 'The same guess is already made.'
      end
    end

    context 'when the guess loses the game' do
      let (:guesses) { ['T', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K'] }

      it 'displays a message that the player lost' do
        expect(game.reload.game_result).to eq 'In progress'
                
        guess_service = GuessService.new(game, { value: 'P' })

        expect(guess_service.call).to eq 'Game over...'
        expect(game.reload.game_result).to eq 'Lose'
        expect(game.guesses.last.value).to eq 'P'
      end
    end

    context 'when game is win' do
      let (:guesses) { ['T', 'U', 'R', 'L'] }
      
      it 'displays a message that the player won' do
        expect(game.reload.game_result).to eq 'In progress'
                
        guess_service = GuessService.new(game, { value: 'E' })
        
        expect(guess_service.call).to eq 'You won!'
        expect(game.reload.game_result).to eq 'Win'
        expect(game.guesses.last.value).to eq 'E'
      end
    end
  end
end
