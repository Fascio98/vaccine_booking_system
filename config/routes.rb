require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'

  namespace :admin do
    root to: "main#index"
    resources :users
    resources :vaccines_items
    resources :bookings
    resources :patients
    resources :business_unit_slots
    get 'business_units/fetch_cities'
    get 'business_units/fetch_districts'

    resources :countries
    resources :cities
    resources :districts
    resources :business_units
    resources :orders
    resources :order_sms_messages
    #resources :main, only: %i[index]
  end

  root to: "main#index"

  get 'slots/fetch_cities'
  get 'slots/fetch_districts'
  get 'slots/fetch_business_units'
  resources :slots, only: :index

  match 'booking/:vaccine', to: 'main#current_step', via: :get, as: :current_step
  match 'next_step', to: 'main#next_step', via: :post
  match 'prev_step', to: 'main#prev_step', via: :post

  match 'cancel_order', to: 'cancel_order#cancel_order', via: :get, as: :cancel_order
  match 'cancel_order_finalize', to: 'cancel_order#cancel_order_finalize', via: [:post, :get], as: :cancel_order_finalize
end
