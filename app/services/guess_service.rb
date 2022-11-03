class GuessService
  def initialize(game, guess_params)
    @game = game
    @guess = game.guesses.build(guess_params)
  end

  def messages
    {
      dupe: "The same guess is already made.",
      gameOver: "Game is already over.",
      win: "You won!",
      lose: "Game over...",
      guessCreated: "Guess was successfully created.",
    }
  end

  def in_progress?
    @game.game_result.include?('In progress')
  end

  def guess_dupe?
    @game.letters_guessed.include?(@guess[:value])
  end

  def game_end
    if @game.game_result == 'Win'
      messages[:win]
    elsif @game.game_result == 'Lose'
      messages[:lose]
    else          
      messages[:guessCreated]
    end
  end
  
  def guess_transaction
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
  end
end
