class GameBuilder
  def initialize(game_params)
    @player_name = game_params[:player_name]
  end

  def call
    @game = Game.new { @player_name }
    @game.secret_word = Game.load_secret_words.sample.upcase
    @game.player_name = @player_name
    @game.game_result = "In progress"

    return @game
  end
end
