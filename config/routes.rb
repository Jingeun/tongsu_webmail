Rails.application.routes.draw do

	#constraints(host: /^(?!www\.)/i) do
	#    get '(*any)' => redirect { |params, request|
	#      URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host.to_s.sub('api.', '')}" }.to_s
	#    }
	#end

	
	root 'home#index'

	devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}
	resources :mailinglists, only: [:index, :show]

	# Non-mailinglist emails
	resources :messages, only: [:index, :show, :new]
	get '/messages/:id/original' => 'messages#original', as: 'original_message'

	post 'users/id_check' => 'home#id_check'
	get  '/dashboard' => 'home#dashboard'

	namespace :api, path: '/', constraints: { subdomain: 'api' } do
		post '/check/registered'
		# post '/check/mailinglist'
		post '/mail/receive'
	end

end
