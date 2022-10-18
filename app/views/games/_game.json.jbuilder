json.extract! game, :id, :player_name, :game_result, :secret_word, :remaining_lives, :created_at, :updated_at
json.url game_url(game, format: :json)
