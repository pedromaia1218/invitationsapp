Rails.application.routes.draw do
  use_doorkeeper
  devise_for :admins

  resources :admins, except: [:show]
  resources :companies, except: [:show]
  resources :invitations, except: [:show]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: 'admins#index', as: :admin_root

  ##############
  ### API v1 ###
  ##############
  namespace :api do
    namespace :v1 do
      resources :invitations, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
