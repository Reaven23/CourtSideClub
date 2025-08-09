Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    get 'dashboard/index'
  end

  root "pages#home"
  get "dashboard", to: "pages#dashboard"

  get "mini-jeux", to: "mini_games#index", as: :mini_games

  resources :quiz_games, only: [:show] do
    member do
      post :start
      post :answer
      post :complete
    end
  end

  resources :vote_campaigns, only: [:index, :show] do
    member do
      post :vote
    end
  end

  resources :articles, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      patch :publish
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be customized by changing the path in config/application.rb
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
