Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  get "/game", to: "game#show"
  resource :guesses, only: [:create, :new, :show]
  resource :images, only: [:create, :new, :show]
end
