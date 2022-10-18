class GuessesController < ApplicationController
  def create    
    game = Game.find(params[:game_id])
    
    if game.game_result != 'In progress'
      redirect_to game, notice: "Game is already over."
      return
    end

    if game.letters_guessed.include?(guess_params[:value])
      redirect_to game, notice: "The same guess is already made."
      return
    end
    
    guess = game.guesses.build(guess_params)

    guess.save!

    if game.secret_word.chars.uniq.count == game.correct_guess
      game.game_result = 'Win'
    end
    
    if game.remaining_lives <= 0
      game.game_result = 'Lose'
    end    

    respond_to do |format|
      if game.save
        format.html do
          if game.game_result == 'Win'
            redirect_to game, notice: "You won!"
          elsif game.game_result == 'Lose'
            redirect_to game, notice: "Game over..."
          else            
            redirect_to game, notice: "Guess was successfully created."
          end
        end

        # format.json { render :show, status: :created, location: game }
      else
        format.html { redirect_to game, alert: "Unable to create guesses." }
        # format.json { render json: guess.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def guess_params
      params.require(:guess).permit(:value)
    end
end
