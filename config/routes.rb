GroupExpenser::Application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]

  resources :users, only: [:show, :update] do
    resources :payments, only: :index
  end

  resources :trips, only: [:create, :show, :index, :update, :destroy] do
    resources :members, controller: :members, only: :index
    resources :expenses, only: [:create, :show, :index, :update, :destroy]

    member do
      get :join
    end
  end

  resources :expenses, only: :show do
    resources :obligations, as: :expense_obligations, controller: :expense_obligations, only: :index
  end

  resources :obligations, only: :show do
    member do
      post :pay
    end
  end
end
