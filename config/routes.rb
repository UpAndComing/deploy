Rails.application.routes.draw do
  resources :comments

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :locations do
  	resources :comments
  	resource :like, module: :locations
  end
  root to: 'visitors#index'
  devise_for :users
end
