require 'rails_helper'

describe Game do
  let (:game) { Game.new(
    id: 5,
    player_name: 'OW',
    game_result: 'In progress',
    secret_word: 'TURTLE'
  ) }

  describe '#remaining_lives' do
    context 'when wrong guesses are made three time' do
      it 'should return integer 6 for remaining_lives' do
        guessed = [
          Guess.create(value: 'T', game: game), # Correct guess
          Guess.create(value: 'A', game: game),
          Guess.create(value: 'S', game: game),
          Guess.create(value: 'D', game: game)
        ]

        expect(game.reload.remaining_lives).to eq 6
      end
    end

    context 'when no wrong guesses are made' do
      it 'should return integer 9 for remaining_lives' do
        guessed = [
          Guess.create(value: 'T', game: game), # Correct guess
          Guess.create(value: 'U', game: game), # Correct guess
          Guess.create(value: 'R', game: game), # Correct guess
          Guess.create(value: 'L', game: game)  # Correct guess
        ]

        expect(game.reload.remaining_lives).to eq 9
      end
    end
  end

  describe "#letters_guessed" do
    context 'when guesses are made' do
      it 'should return array of guessed letters' do
        guessed = [
          Guess.create(value: 'A', game: game),
          Guess.create(value: 'S', game: game),
          Guess.create(value: 'D', game: game)
        ]

        expect(game.reload.letters_guessed).to eq ['A', 'S', 'D']
      end
    end
  end

  describe '#correct_guess' do
    context 'when 2 correct guesses are made' do
      it 'should return integer 2' do
        guessed = [
          Guess.create(value: 'T', game: game), # Correct letter
          Guess.create(value: 'U', game: game), # Correct letter
          Guess.create(value: 'S', game: game)
        ]

        expect(game.correct_guess).to eq 2
      end
    end

    context 'when no correct guess is made' do
      it 'should return integer 0' do
        guessed = [
          Guess.create(value: 'A', game: game),
          Guess.create(value: 'S', game: game),
          Guess.create(value: 'D', game: game)
        ]

        expect(game.correct_guess).to eq 0
      end
    end
  end

  describe "#formatted_updated_at" do
    it 'shoud show the right time' do
      allow(game.updated_at).to receive(:strftime).with('%Y/%m/%d - %H:%M %p').and_return('2022/10/06 - 20:08 PM')
      expect(game.formatted_updated_at).to eq '2022/10/06 - 20:08 PM'
    end
  end

  describe "#check_dupe?(letter)" do
    context 'when the same guess is made' do
      it 'should return true' do
        guessed = [
          Guess.create(value: 'A', game: game),
          Guess.create(value: 'S', game: game),
          Guess.create(value: 'D', game: game)
        ]

        expect(game.reload.check_dupe?('A')).to be true
      end
    end

    context 'when no same guess is made' do
      it 'should return false' do
        guessed = [
          Guess.create(value: 'A', game: game),
          Guess.create(value: 'S', game: game),
          Guess.create(value: 'D', game: game)
        ]

        expect(game.reload.check_dupe?('Z')).to be false
      end
    end
  end
end
