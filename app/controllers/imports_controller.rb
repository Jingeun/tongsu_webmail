class ImportsController < ApplicationController
	before_action :authenticate_user!
	before_action :get_not_read_message, only: [:new]
	before_action :get_groups, only: [:new]

	def new
		@import = current_user.imports.new
	end

	def create
		current_user.imports.create(
			type: 		params[:type],
			email: 		params[:email],
			password: 	params[:password]
		)
		
		`java -jar /home/webserver/mail_import.jar #{params[:email]} #{params[:password]} #{params[:type]} #{current_user.uid}`
	end
end
