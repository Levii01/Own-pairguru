Rails.application.routes.draw do
  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/api/graphql' if Rails.env.development?

  devise_for :users

  root "home#welcome"
  resources :comments, only: [:create, :destroy] do
    collection do
      get "ranking"
    end
  end
  resources :genres, only: :index do
    member do
      get "movies"
    end
  end
  resources :movies, only: [:index, :show] do
    member do
      get :send_info
    end
    collection do
      get :export
    end
  end
  namespace :api, defaults: { format: :json } do
    match "graphql", to: "graphql#execute", via: [:get, :post]
  end
end
