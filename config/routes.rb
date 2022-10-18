Rails.application.routes.draw do
  resources :games, only: [:index, :new, :update, :destroy, :create, :show] do 
    resources :guesses, only: [:create]
  end

  root "games#index"
end
