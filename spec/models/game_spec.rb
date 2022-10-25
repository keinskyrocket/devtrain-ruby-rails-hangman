require 'rails_helper'

describe Game do
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

  describe '#remaining_lives' do
    context 'when wrong guesses are made three time' do
      let (:guesses) { ['T', 'A', 'S', 'D'] }

      it 'should return integer 6 for remaining_lives' do
        expect(game.reload.remaining_lives).to eq 6
      end
    end

    context 'when no wrong guesses are made' do
      let (:guesses) { ['T', 'U', 'R', 'L'] }

      it 'should return integer 9 for remaining_lives' do
        expect(game.reload.remaining_lives).to eq 9
      end
    end
  end

  describe "#letters_guessed" do
    context 'when guesses are made' do
      let (:guesses) { ['A', 'S', 'D'] }

      it 'returns array of guessed letters' do
        expect(game.reload.letters_guessed).to eq guesses
      end
    end
  end

  describe '#correct_guess' do
    context 'when 2 correct guesses are made' do
      let (:guesses) { ['T', 'U', 'S'] }

      it 'returns integer 2' do
        expect(game.correct_guess).to eq 2
      end
    end

    context 'when no correct guess is made' do
      let (:guesses) { ['A', 'S', 'D'] }

      it 'should return integer 0' do
        expect(game.correct_guess).to eq 0
      end
    end
  end

  describe "#formatted_updated_at" do
    it 'shoud show the right time' do
      game.update(updated_at: DateTime.parse('6 Oct 2022 20:08:00+00:00'))
      expect(game.formatted_updated_at).to eq '2022/10/06 - 20:08'
    end
  end

  describe "#check_dupe?(letter)" do
    context 'when the same guess is made' do
      let (:guesses) { ['A', 'S', 'D'] }

      it 'should return true' do
        expect(game.reload.check_dupe?('A')).to be true
      end
    end

    context 'when no same guess is made' do
      let (:guesses) { ['A', 'S', 'D'] }
      
      it 'should return false' do
        expect(game.reload.check_dupe?('Z')).to be false
      end
    end
  end
end
