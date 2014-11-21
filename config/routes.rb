Secretsanta::Application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", omniauth_callbacks: "omniauth_callbacks" } 
  devise_scope :user do
    get "login", to: "devise/sessions#new", as: "login"
    delete "logout", to: "devise/sessions#destroy", as: "logout"
    get "signup", to: "users/registrations#new", as: "signup"
    resources :groups, path: "/", only: :none do
      get "signup", to: "users/registrations#new", as: "signup"
    end
  end

  get "about", to: "pages#about", as: :about
  get "tips", to: "pages#tips", as: :tips
  get "2013", to: "pages#blog_roll", as: :blog_roll
  get "run-group", to: "pages#run_group", as: :run_group
  get "open-groups", to: "pages#groups", as: :groups_page

  put "enquiry", to: "groups#enquiry", as: :enquiry_group

  
  namespace :santa do
    get "/", to: "groups#index", as: "root"
    resources :groups do
      resources :content, :matches
      resources :users do
        collection do
          get "assign"
          put "set_assignments"
        end
      end
    end
    resources :messages, only: [:new, :create]
  end

  namespace :elves do
    get "/", to: "groups#show"
    # resources :content, only: [:index, :show, :edit, :update]
    resources :users do
      member do
        put "remove"
        put "replace"
        get "pull_out"
      end
    end
  end

  resources :groups, path: "/", only: :show do
    # get "/signup", to: "devise/registrations#new", as: "signup"
    resources :content, path: "gifts", only: [:new, :show, :edit, :update, :index] do
      member do
        put "edit", to: "content#update"
        put "send_gift"
      end
    end
  end
  resources :users

  root to: "pages#home"
end