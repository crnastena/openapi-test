# frozen_string_literal: true
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      # gives errors
      # mount Perk::Engine => "/", as: :breaker
      # mount Perk::Engine => "/"

      # works
      mount Perk::Engine => "/perk"

      namespace :capital do
        resources :capital, only: [:index]
      end

      resources :greetings, only: [:index]
      resources :movie, only: [:index]

      # does not work when running engine specs from project app.
      # it still works when running just project app specs.
      # mount Perk::Engine => "/"
    end
  end
end
