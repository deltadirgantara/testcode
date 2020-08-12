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
    resources :system_informations

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
    resources :banks

    resources :trxes
    get '/transaction/daily/recap', to: 'trxes#daily_recap', as: "daily_trx_recap"
    get '/transaction/daily/recap_item', to: 'trxes#daily_recap_item', as: "daily_trx_item_recap"
    get '/transaction/monthly/recap', to: 'trxes#monthly_recap', as: "monthly_trx_recap"

    resources :trx_buys
    get '/transaction_sell/daily/recap', to: 'trx_buys#daily_recap', as: "daily_trx_buy_recap"
    get '/transaction_sell/daily/recap_item', to: 'trx_buys#daily_recap_item', as: "daily_trx_buy_item_recap"
    get '/transaction_sell/monthly/recap', to: 'trx_buys#monthly_recap', as: "monthly_trx_buy_recap"


    resources :taxs
    resources :operationals
    resources :fix_costs
    resources :modals
    resources :other_incomes
    resources :other_outcomes
    resources :asset_values
    resources :debts
    resources :receivables
    resources :kasbons
    resources :payments

    resources :cash_flows
    resources :bank_flows

    resources :custom_orders
    resources :melts


    get '/refresh/asset_values', to: 'asset_values#refresh', as: 'refresh_asset_values'


    resources :activities, only: %i[index show]

    get '/api/:api_type', to: 'apis#index'
    
end
