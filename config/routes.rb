Rails.application.routes.draw do
	
	Clearance.configure do |config|
  		config.routes = false
	end
	root :to => "homes#index"

	resources :registers, only: %i[new create]

	# Clearance
	resource :session, controller: 'sessions', only:  %i[create]
  	get '/sign_in', to: 'sessions#new', as: 'sign_in'
  	delete '/sign_out', to: 'sessions#destroy'

  	resources :users
  	resources :stores
    resources :customers
    resources :notifications
  	resources :categories
  	resources :gold_types
  	resources :sub_categories
  	resources :items
    resources :gold_prices
    resources :buckets
    resources :suppliers

    resources :custom_orders
end
