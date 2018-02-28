Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/123', as: 'rails_admin'
  # =======================
  # GENERAL
  # =======================

   # You can have the root of your site routed with "root"
  root 'shared#index'

  # Send support form data
  match '/send_support_request' => 'shared#send_support_request', via: [:post]

  match '/features' => 'shared#features', via: [:get, :post]
  match '/contact' => 'shared#contact', via: [:get, :post]

  # =======================
  # USERS
  # =======================

  # User Authentication
  devise_for :users, :controllers => {omniauth_callbacks: 'omniauth_callbacks'}

  # After signup request extra user details
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  resources :users, except: [:show, :new, :create] do
    collection do
      match "/dashboard", to: "boards#index", via: [:get, :post]
    end
  end

  # match '/manage' => 'board#index'

  resources :boards do
    put :sort, on: :collection
    resources :swimlanes, shallow: true
  end

  resources :swimlanes

  resources :tasks do
	member do
		post 'toggle'
	  end
  end

  resources :dashboards

  resources :cards do
      resources :tasks, shallow: true
  end


end
