Rails.application.routes.draw do
  root to: redirect('/tasks')
  get '/login', to: 'users#new'
  resources :tasks
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
