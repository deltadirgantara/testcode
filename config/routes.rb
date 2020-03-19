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
    
    resources :taxs
    resources :operationals
    resources :fix_costs
    resources :modals
    resources :other_incomes
    resources :other_outcomes

    resources :cash_flows
    resources :bank_flows

    resources :custom_orders



    resources :activities, only: %i[index show]
    
end
