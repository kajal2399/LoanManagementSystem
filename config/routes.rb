require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  
  root 'home#index'

  namespace :admin do
    get 'dashboard' => 'dashboard#index', as: :dashboard
    resources :loans, only: [:index, :show, :update]
  end

  get 'profile' => 'users#show', as: :user_profile

  resources :loans, only: [:index, :new, :create, :show] do
    member do
      patch :confirm
      patch :reject
      patch :repay
    end
  end

end
