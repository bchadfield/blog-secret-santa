Secretsanta::Application.routes.draw do
  get "/auth/:provider/callback", to: "sessions#create"
  get "/logout", to: "sessions#destroy", as: :logout
  get "/login", to: "sessions#new", as: :login

  resources :users, :content, :draws

  root to: "draws#show"
end
