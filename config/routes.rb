Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    root 'devise/sessions#new'
  end

  resources :products, only: %i[new create edit update destroy index]
  
end

