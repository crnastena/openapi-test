Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do

      # gives errors
      # mount Breaker::Engine => "/", as: :breaker
      mount Breaker::Engine => "/"

      # works
      # mount Breaker::Engine => "/breaker"

      resources :testers, only: [:index]

      # works
      # mount Breaker::Engine => "/"
    end
  end
end
