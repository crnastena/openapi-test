Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :maximus, only: [:index]
      resources :taxi, only: [:index]
    end
  end
end
