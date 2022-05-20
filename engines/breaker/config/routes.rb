Rails.application.routes.draw do
  resources :hullo, only: [:index]
end
