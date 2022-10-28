class GuessesController < ApplicationController
  def create    
    game = Game.find(params[:game_id])
    guess_transaction = GuessTransaction.new(game, guess_params)

    if game.game_result != 'In progress'
      redirect_to game, notice: "Game is already over."
      return
    end
    
    if game.letters_guessed.include?(guess_params[:value])
      redirect_to game, notice: "The same guess is already made."
      return
    end
    
    guess_transaction.call

    if game.game_result == 'Win'
      redirect_to game, notice: "You won!"
    elsif game.game_result == 'Lose'
      redirect_to game, notice: "Game over..."
    else            
      redirect_to game, notice: "Guess was successfully created."
    end
 
  rescue ActiveRecord::RecordInvalid
    redirect_to game, alert: "Unable to create guesses."
   
  end

  private

    def guess_params
      params.require(:guess).permit(:value)
    end
end
