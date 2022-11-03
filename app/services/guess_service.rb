class GuessService
  def initialize(game, guess_params)
    @game = game
    @guess = game.guesses.build(guess_params)
  end

  def call
    messages = {
      gameOver: "Game is already over.",
      dupe: "The same guess is already made.",
      win: "You won!",
      lose: "Game over...",
      guessCreated: "Guess was successfully created.",
    }

    if !@game.game_result.include?('In progress')
      messages[:gameOver]
      return
    end

    if @game.letters_guessed.include?(@guess[:value])
      messages[:dupe]
      return
    end

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

    if @game.game_result == 'Win'
      messages[:win]
    elsif @game.game_result == 'Lose'
      messages[:lose]
    else          
      messages[:guessCreated]
    end

  end
end
