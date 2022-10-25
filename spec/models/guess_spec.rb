require 'rails_helper'

describe Guess do
  let (:game) { Game.new(
    id: 5,
    player_name: 'OW',
    game_result: 'In progress',
    secret_word: 'TURTLE'
  ) }

  describe 'validations' do
    it 'should allow single letter' do
      expect(Guess.new(value: 'A', game: game)).to be_valid
    end

    it 'should not allow lowercase' do
      expect(Guess.new(value: 'a', game: game)).not_to be_valid
    end

    it 'should not allow non-alphabetical character' do
      expect(Guess.new(value: '&', game: game)).not_to be_valid
    end

    it 'should not allow emoji' do
      expect(Guess.new(value: '🐢', game: game)).not_to be_valid
    end
  end
end
