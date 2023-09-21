Rails.application.routes.draw do
  get '/cadena_preview/:token', to: 'cadena_preview#show', as: 'cadena_preview'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: :index do
    member do
      post 'login_as'
    end
  end

  get 'users/:id', to: 'users#show', as: 'user'
  get 'users/:id/abandon_complete_profile', to: 'users#abandon_complete_profile', as: 'abandon_complete_profile'

  get 'users/:id/complete_profile', to: 'users#complete_profile', as: 'complete_profile'
  patch 'users/:id/complete_profile', to: 'users#update', as: 'update_profile'
  patch '/set_date', to: 'application#set_date', as: 'set_date'
  patch 'users/:id/quick_deposit', to: 'users#quick_deposit', as: 'quick_deposit'

  resources :cadenas do
    resources :invitations do
      member do
        get :accept
      end
    end
    member do
      delete 'remove_user/:user_id', to: 'cadenas#remove_user', as: 'remove_user'
      patch :request_approval
      patch :assign_positions
    end
    resources :payments, only: [:new, :create, :index]
    get 'make_all_payments', to: 'payments#make_all_payments'
  end
  get 'terms', to: 'pages#terms', as: 'terms'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#index"
end
