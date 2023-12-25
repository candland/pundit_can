Rails.application.routes.draw do
  resources :users do
    resources :posts
  end

  resources :special, controller: :mis_matched
  resources :missing, controller: :missing
  resources :missing_scope, controller: :missing_scope
  resources :skips
  resources :devise, controller: :devise
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
