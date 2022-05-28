Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :warehouses, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :suppliers, only: [:index, :show, :new, :create, :edit, :update]

  authenticate :user do
    resources :product_models, only: [:index, :show, :new, :create]
  end

  resources :orders, only: [:new, :create, :show, :index, :edit, :update] do
    resources :order_items, only: [:new, :create]
    get 'search', on: :collection
    post 'delivered', on: :member
    post 'canceled', on: :member
  end
end
