Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    root to: "main#index"
    resources :users
    resources :vaccines_items
    resources :bookings
    resources :patients
    get 'patients/:id', to: 'patients#show', as: 'show'
    #resources :main, only: %i[index]
  end

  root to: "main#index"

  match 'booking/:vaccine', to: 'main#current_step', via: :get, as: :current_step
  match 'next_step', to: 'main#next_step', via: :post
end
