Rails.application.routes.draw do
  get 'home/index'
  get 'home/login'
  resources :tasks
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
