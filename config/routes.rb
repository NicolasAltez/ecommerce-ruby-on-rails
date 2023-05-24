Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    root 'devise/sessions#new'
  end

  resources :products


end
