Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  get "dashboard", to: "pages#dashboard"

  # Mini-jeux
  get "mini-jeux", to: "mini_games#index", as: :mini_games

  # Quiz Games
  resources :quiz_games, only: [:show] do
    member do
      post :start    # Démarre une session de quiz
      post :answer   # Soumet une réponse
      post :complete # Finalise le quiz
    end
  end

  # Vote campaigns
  resources :vote_campaigns, only: [:index, :show] do
    member do
      post :vote
    end
  end

  # Articles
  resources :articles, only: [:index, :show, :new, :create, :edit, :update]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be customized by changing the path in config/application.rb
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
