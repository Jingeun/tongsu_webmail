class HomeController < ApplicationController
	before_action :authenticate_user!, only: [:index]
	before_action :get_not_read_message, only: [:index]

	def index
	end

	def id_check
		id = params[:uid]
			#@availabe = false
		check = User.find_by_uid(id)
		
		if check.nil?
			head 204
		else
			head 404
		end
	end
end
