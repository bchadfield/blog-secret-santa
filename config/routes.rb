Secretsanta::Application.routes.draw do
  get "/auth/:provider/callback", to: "sessions#create"
  get "/logout", to: "sessions#destroy", as: :logout
  get "/about", to: "pages#about", as: :about

  resources :content, only: [:new, :show, :update] do
    collection do
      get "/:draw_id", to: "content#index", as: ""
    end
  end
  resources :draws, only: :show
  resources :users do
  	member do
  		get "email"
  		patch "set_email"
  	end
  end

  root to: "draws#show"
end
