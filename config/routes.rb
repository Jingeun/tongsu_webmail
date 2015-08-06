Rails.application.routes.draw do
	
	devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}
	# You can have the root of your site routed with "root"
	root 'home#index'

	resources :timelines, except: :create
	post '/timelines' => 'timelines#index'

	resources :test
	# Example of regular route:
	#   get 'products/:id' => 'catalog#view
	#id check
	post 'users/id_check' => 'login#id_check'

end
