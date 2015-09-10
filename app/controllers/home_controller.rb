class HomeController < ApplicationController
	before_action :authenticate_user!, only: [:dashboard]
	before_action :get_not_read_message, only: [:dashboard]
	before_action :get_groups, only: [:dashboard]

	def index
		if user_signed_in?
			redirect_to dashboard_path
		else
			render layout: false
		end
	end

	def dashboard
		@top = Mailinglist.top
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
