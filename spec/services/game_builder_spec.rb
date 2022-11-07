require 'rails_helper'

describe GameBuilder do
  let(:valid_params) { {
    player_name: 'OW'
  } }

  it 'sets up creates a new game with correct defaults and a secret word' do
    allow(Game).to receive(:load_secret_words).and_return(['test'])
    
    game = GameBuilder.new(valid_params).call
    expect(game[:secret_word]).to eq 'TEST'
    expect(game[:player_name]).to eq 'OW'
    expect(game[:game_result]).to eq 'In progress'
  end
end
