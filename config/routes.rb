Secretsanta::Application.routes.draw do
  get "/auth/:provider/callback", to: "sessions#create"
  get "/logout", to: "sessions#destroy", as: :logout
  get "/about", to: "pages#about", as: :about
  get "/tips", to: "pages#tips", as: :tips

  constraints subdomain: /[a-zA-Z\-]+/ do
    get "/", to: "pools#show"
    resources :content, path: "gifts", only: [:new, :show, :edit, :update, :index] do
      member do
        put "edit", to: "content#update"
        put "send_gift"
      end
    end
  end
  resources :users do
  	member do
  		get "email"
  		patch "set_email"
  	end
  end

  root to: "pages#about"
end