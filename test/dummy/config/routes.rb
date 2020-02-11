Rails.application.routes.draw do
  resources :posts
  resources :books
  root to: 'posts#index'
end
