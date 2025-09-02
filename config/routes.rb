Rails.application.routes.draw do
  get 'notifications/create'
  devise_for :users

  namespace :admin do
    # Dashboard
    get 'dashboard/index'
    get 'dashboard', to: 'dashboard#index', as: :dashboard

    # Admin actions
    patch 'dashboard/users/:id/toggle_admin', to: 'dashboard#toggle_user_admin', as: :toggle_user_admin
    patch 'dashboard', to: 'dashboard#mark_notification_read', as: :mark_notification_read
    delete 'dashboard', to: 'dashboard#delete_notification', as: :delete_notification

    # Quiz games management
    resources :quiz_games do
      resources :questions
    end

    # Articles management in dashboard
    resources :articles, only: [:create, :edit, :update, :destroy] do
      member do
        patch :publish
      end
    end

    resources :vote_campaigns, only: [:show, :new, :create, :edit, :update, :destroy] do
      get :test, on: :collection
      patch :update, on: :member
      post :update, on: :member
    end
    resources :players, only: [:new, :create, :edit, :update, :destroy]
  end

  root "pages#home"
  get "contact", to: "pages#contact", as: :contact
  get "avantages", to: "pages#advantages", as: :advantages
  get "historique", to: "pages#historique", as: :historique
  get "faq", to: "pages#faq", as: :faq
  get "partenariat", to: "pages#partenariat", as: :partenariat
  get "nos-partenaires", to: "pages#nos_partenaires", as: :nos_partenaires
  get "dashboard", to: "pages#dashboard"
  get "decouvrir", to: "pages#discover", as: :discover

  get "mini-jeux", to: "mini_games#index", as: :mini_games

  resources :quiz_games, only: [:show] do
    member do
      post :start
      post :answer
      post :complete
    end
  end

  resources :notifications, only: [:create]

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
