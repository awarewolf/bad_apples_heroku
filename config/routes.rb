Rails.application.routes.draw do

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resources :movies, concerns: :paginatable do
    resources :reviews, concerns: :paginatable
  end

  namespace :admin do
    resources :users, concerns: :paginatable
  end

  resources :users, only: [:new, :create] do
    member do
      get :confirm_email
    end
  end

  resources :sessions, only: [:new, :create, :destroy] do
    # get 'login' => :new
    # post 'login' => :create
    # delete 'logout' => :destroy
    # post 'users/' => 'users#create', :as => 'user'
  end

  # resources :sessions, only: [:new, :create, :destroy]

  # get 'signup', to: 'users#new', as: 'signup'
  # post 'signup', to: 'users#create', as: 'signup'
  # get 'login', to: 'sessions#new', as: 'login'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  # get 'logout', to: 'sessions#destroy', as: 'logout'

  root 'movies#index'

end
