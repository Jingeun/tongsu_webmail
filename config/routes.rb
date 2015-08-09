Rails.application.routes.draw do
	
	root 'home#index'

	devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}
	resources :timelines, except: :create

	post 'users/id_check' => 'home#id_check'

	namespace :api, path: '/', constraints: { subdomain: 'api' } do
		get '/check/registered'
		post '/check/mailinglist'
	end

end
