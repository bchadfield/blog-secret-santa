Secretsanta::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  # get "/auth/:provider/callback", to: "sessions#create"
  # get "/logout", to: "sessions#destroy", as: :logout
  get "/about", to: "pages#about", as: :about
  get "/tips", to: "pages#tips", as: :tips

  
  constraints subdomain: "santa" do
    scope module: "santa" do
      get "/", to: "pools#index", as: "santa_root"
      resources :pools do
        resources :content, :matches
        resources :users do
          collection do
            get "assign"
            put "set_assignments"
          end
        end
      end
    end
  end

  constraints subdomain: /[a-zA-Z\-]+/ do
    get "/", to: "pools#show", as: "elves_root"
    resources :content, path: "gifts", only: [:new, :show, :edit, :update, :index] do
      member do
        put "edit", to: "content#update"
        put "send_gift"
      end
    end

    get "elves", to: "elves/pools#show"
    namespace :elves do
      resources :users, :matches, :content, only: [:index, :show, :edit, :update]
    end
  end
  resources :users

  root to: "pages#home"
end