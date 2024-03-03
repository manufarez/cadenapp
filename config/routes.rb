Rails.application.routes.draw do
  authenticate :user, ->(u) { u.is_admin? } do
    mount GoodJob::Engine, at: "good_job"
  end
  get '/cadena_preview/:token', to: 'cadena_preview#show', as: 'cadena_preview'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: :index do
    member do
      post 'login_as'
    end
  end

  resources :newsletter_subscribers

  get 'users/:id', to: 'users#show', as: 'user'
  get 'users/:id/abandon_complete_profile', to: 'users#abandon_complete_profile', as: 'abandon_complete_profile'

  patch '/set_date', to: 'application#set_date', as: 'set_date'

  resources :users do
    get 'complete_profile', to: 'users#complete_profile', as: 'complete_profile'
    patch 'update_profile', to: 'users#update', as: 'update_profile'
    get 'deposit', to: 'users#deposit', as: 'deposit'
    post 'deposit/payment_methods', to: 'users#payment_methods', as: 'payment_methods'
    get 'deposit/payment_form', to: 'users#deposit'
    post 'deposit/payment_form', to: 'users#payment_form', as: 'payment_form'
    patch 'quick_deposit', to: 'users#quick_deposit', as: 'quick_deposit'
  end

  resources :cadenas do
    resources :invitations do
      member do
        get :decline
        get :accept
      end
    end
    member do
      delete 'remove_participant/:participant_id', to: 'cadenas#remove_participant', as: 'remove_participant'
      patch :start_participants_approval
      patch :assign_positions
      patch :change_status
    end
    resources :payments, only: [:new, :create, :index]
    get 'make_all_payments', to: 'payments#make_all_payments'
  end
  get 'terms', to: 'pages#terms', as: 'terms'
  get 'prueba_cerrada', to: 'pages#closed_test'
  get 'faq', to:'pages#faq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#index"
end
