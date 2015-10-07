Rails.application.routes.draw do

	#constraints(host: /^(?!www\.)/i) do
	#    get '(*any)' => redirect { |params, request|
	#      URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host.to_s.sub('api.', '')}" }.to_s
	#    }
	#end

	
	root 'home#index'

	resources :imports, only: [:new, :create]
	
	devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}
	resources :mailinglists, only: [:index, :show] do
		resources :mails, only: [:show]
	end
	post '/mailinglists/see_more'
	post '/mailinglists/get_comments'
	post '/mailinglists/create_comments'
	post '/mailinglists/likes'

	# Non-mailinglist emails
	resources :messages
	get '/imported/messages' => 'messages#import', as: 'import_messages'
	get '/messages/:id/original' => 'messages#original', as: 'original_message'
	get '/sent/messages' => 'messages#sent_messages', as: 'sent_messages'
	get '/sent/messages/:id' => 'messages#sent_messages_show', as: 'sent_message'

	post 'users/id_check' => 'home#id_check'
	get  '/dashboard' => 'home#dashboard'
    get  '/board' => 'home#board'
    post  '/subscribe' => 'home#subscribe'

	namespace :api, path: '/', constraints: { subdomain: 'api' } do
		post '/check/registered'
		# post '/check/mailinglist'
		post '/mail/receive'
		# attachments download
		post '/file/download' => 'mail#download', as: 'download'
		post '/send/keywords' => 'mail#keyword'
	end

end
