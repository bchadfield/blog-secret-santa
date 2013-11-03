Secretsanta::Application.routes.draw do
  get "/auth/:provider/callback", to: "sessions#create"
  get "/logout", to: "sessions#destroy", as: :logout
  get "/login", to: "sessions#new", as: :login

  resources :content, :draws
  resources :users do
  	member do
  		get "email"
  		patch "set_email"
  	end
  end

  root to: "draws#show"
end
