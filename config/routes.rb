Rails.application.routes.draw do
  devise_for :users
  resources :users, only: :index do
    member do
      post 'login_as'
    end
  end
  resources :cadenas do
    resources :invitations
  end
  get 'pages/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#index"
end
