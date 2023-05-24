Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    root 'devise/sessions#new'
  end

  namespace :admin do
    resources :user_management, path: 'users', except: [:show]
  end
  

  resources :products
end
