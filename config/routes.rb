Secretsanta::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" } 
  devise_scope :user do
    get "/login", to: "devise/sessions#new", as: "login"
    delete "/logout", to: "devise/sessions#destroy", as: "logout"
    get "/signup", to: "devise/registrations#new", as: "signup"
  end

  get "/about", to: "pages#about", as: :about
  get "/tips", to: "pages#tips", as: :tips
  get "/2013", to: "pages#blog_roll", as: :blog_roll
  get "/run_group", to: "pages#run_group", as: :run_group
  get "/groups", to: "pages#groups", as: :groups_page

  put "/enquiry", to: "groups#enquiry", as: :enquiry_group

  
  constraints subdomain: "santa" do
    scope module: "santa" do
      get "/", to: "groups#index", as: "santa_root"
      resources :groups do
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
    get "/", to: "groups#show"
    resources :content, path: "gifts", only: [:new, :show, :edit, :update, :index] do
      member do
        put "edit", to: "content#update"
        put "send_gift"
      end
    end

    get "elves", to: "elves/groups#show"
    namespace :elves do
      resources :matches, :content, only: [:index, :show, :edit, :update]
      resources :users do
        member do
          put "remove"
          put "replace"
          get "pull_out"
        end
      end
    end
  end
  resources :users

  root to: "pages#home"
end