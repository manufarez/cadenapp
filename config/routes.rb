Rails.application.routes.draw do
  devise_for :users
  resources :users, only: :index do
    member do
      post 'login_as'
    end
  end

  get 'users/:id/complete_profile', to: 'users#complete_profile', as: 'complete_profile'
  patch 'users/:id/complete_profile', to: 'users#update', as: 'update_profile'

  resources :cadenas do
    resources :invitations
  end
  get 'pages/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#index"
end
