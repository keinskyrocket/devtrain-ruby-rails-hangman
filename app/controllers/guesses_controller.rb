class GuessesController < ApplicationController
  def create    
    game = Game.find(params[:game_id])
    guess_service = GuessService.new(game, guess_params)


    if !guess_service.in_progress?
      redirect_to game, notice: guess_service.messages[:gameOver]
      return
    end

    if guess_service.guess_dupe?
      redirect_to game, notice: guess_service.messages[:dupe]
      return
    end

    guess_service.guess_transaction
    
    redirect_to game, notice: guess_service.game_end
 
  rescue ActiveRecord::RecordInvalid
    redirect_to game, alert: "Unable to create guesses."
   
  end

  private

    def guess_params
      params.require(:guess).permit(:value)
    end
end
