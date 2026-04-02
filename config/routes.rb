Rails.application.routes.draw do
  get "webmanifest"    => "pwa#manifest"
  get "service-worker" => "pwa#service_worker"

  get 'notifications/create'
  devise_for :users


  get '/switch_locale/:locale', to: 'locales#switch', as: :switch_locale

  namespace :admin do
    get 'dashboard/index'
    get 'dashboard', to: 'dashboard#index', as: :dashboard

    patch 'dashboard/users/:id/toggle_admin', to: 'dashboard#toggle_user_admin', as: :toggle_user_admin
    patch 'dashboard', to: 'dashboard#mark_notification_read', as: :mark_notification_read
    delete 'dashboard', to: 'dashboard#delete_notification', as: :delete_notification

    resources :quiz_games do
      resources :questions
    end

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
    resources :shop_products, only: [:index, :new, :create, :edit, :update]
    resources :shop_orders, only: [:index, :show, :update]
  end

  get "boutique", to: "shop#index", as: :shop
  post "boutique/checkout", to: "shop#create_checkout", as: :shop_checkout
  get "boutique/confirmation", to: "shop#success", as: :shop_success
  get "boutique/annulation", to: "shop#cancel", as: :shop_cancel
  post "webhooks/stripe", to: "webhooks#stripe", as: :stripe_webhooks

  root "pages#home"
  get "contact", to: "pages#contact", as: :contact
  get "avantages", to: "pages#advantages", as: :advantages
  get "historique", to: "pages#historique", as: :historique
  get "faq", to: "pages#faq", as: :faq
  get "partenariat", to: "pages#partenariat", as: :partenariat
  get "nos-partenaires", to: "pages#nos_partenaires", as: :nos_partenaires
  get "equipe", to: "pages#equipe", as: :equipe
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

  resources :roll_call_entries, only: [:new, :create, :index]
  get "appel", to: "roll_call_entries#new", as: :appel

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
