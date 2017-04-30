GroupExpenser::Application.routes.draw do
  devise_for :users, skip: :omniauth_callbacks, controllers: {
    registrations: 'registrations'
  }

  namespace :api do
    mount_devise_token_auth_for 'User', at: 'v1/auth', skip: [:omniauth_callbacks], controllers: {
      registrations: 'api/v1/registrations',
      sessions: 'api/v1/sessions'
    }
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :update] do
        resources :payments, only: :index
      end

      resources :trips, only: [:create, :show, :index, :update, :destroy] do
        resources :members, controller: :members, only: [:index, :create, :update, :destroy]
        resources :expenses, only: [:create, :show, :index, :update, :destroy]
      end

      resources :expenses, only: :show do
        resources :obligations, as: :expense_obligations, controller: :expense_obligations, only: :index
      end

      resources :obligations, as: :expense_obligations, controller: :expense_obligations, only: :show do
        member do
          post :pay
          delete :unpay
        end
      end
    end
  end

  resources :trips, only: nil do
    resources :joins, controller: :trip_joins, only: [:new, :create]
  end

  get '/join/:trip_id', to: 'trip_joins#new', as: :join_trip
  get '/privacy', to: 'home#privacy'

  root to: 'home#index'
end
