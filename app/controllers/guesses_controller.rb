class GuessesController < ApplicationController
  def create    
    game = Game.find(params[:game_id])
    guess_service = GuessService.new(game, guess_params)    
    
    flash[:notice] = guess_service.call
    guess_service.call
    redirect_to game
 
  rescue ActiveRecord::RecordInvalid
    redirect_to game, alert: "Unable to create guesses."
   
  end

  private

    def guess_params
      params.require(:guess).permit(:value)
    end
end
