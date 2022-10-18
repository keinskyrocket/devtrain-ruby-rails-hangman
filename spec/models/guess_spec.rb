require 'rails_helper'

describe Guess do
  let (:game) { Game.new(player_name: 'OW', game_result: 'In progress', secret_word: 'TURTLE') }

  describe 'validations' do
    it 'should allow single letter' do
      expect(Guess.new(value: 'A', game: game)).to be_valid
    end

    it 'should allow uppercase' do
      expect(Guess.new(value: 'a', game: game)).not_to be_valid
    end

    it 'should allow character between A and Z' do
      expect(Guess.new(value: '&', game: game)).not_to be_valid
    end

    it 'should NOT allow non-character' do
      expect(Guess.new(value: '🐢', game: game)).not_to be_valid
    end
  end
end
