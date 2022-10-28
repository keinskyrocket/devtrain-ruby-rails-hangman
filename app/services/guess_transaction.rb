class GuessTransaction
  def initialize(game, guess_params)
    @game = game
    @guess = game.guesses.build(guess_params)
  end

  def call
    @guess.transaction do
      @guess.save!

      if @game.secret_word.chars.uniq.count == @game.correct_guess
        @game.game_result = 'Win'
      end

      if @game.remaining_lives <= 0
        @game.game_result = 'Lose'
      end   

      @game.save!
    end

    # create the guess
    # update the game (if needed)
    # reject guesses when they’re duplicates
    # reject guesses when the game is over
    # return something that says
      # If the guess was correct
      # If the guess was wrong
      # If the game is already over
      # If the guess is repeated
      # If the game was won
      # If the game was lost
  end
end
