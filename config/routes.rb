Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  delete 'users/sign_out', to: 'devise/sessions#destroy', as: 'logout'


  devise_scope :user do
    root 'devise/sessions#new'
  end

  namespace :admin do
    resources :user_management, path: 'users', except: [:show]
  end

  post 'add_to_cart/:id', to: 'shopping_cart#add_to_cart', as: 'add_to_cart'
  get 'shopping_cart/index', to: 'shopping_cart#index', as: 'shopping_cart_index'
  get 'shopping_cart/cart', to: 'shopping_cart#cart', as: 'shopping_cart'
  delete 'shopping_cart/remove_from_cart/:id', to: 'shopping_cart#remove_from_cart', as: 'remove_from_cart_product'
  delete 'shopping_cart/remove_all_from_cart/:id', to: 'shopping_cart#remove_all_from_cart', as: 'remove_all_from_cart_product'
  post 'shopping_cart/generate_order', to: 'shopping_cart#generate_order', as: 'generate_order'
  get 'order_history', to: 'orders#order_history', as: 'order_history'

  
  resources :products
  resources :orders
end
