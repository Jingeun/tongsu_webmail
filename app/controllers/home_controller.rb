class HomeController < ApplicationController
	before_action :authenticate_user!, only: [:dashboard, :board]
	before_action :get_not_read_message, only: [:dashboard, :import, :board]
	before_action :get_groups, only: [:dashboard, :import, :board]

	def index
		if user_signed_in?
			redirect_to dashboard_path
		else
			render layout: false
		end
	end

	def import
	end

	def dashboard
		test   = Rails.application.routes.url_helpers.message_path(Message.first)
		p "DEBUG::DASHBOARD #{test}"
		@top   = Mailinglist.unscoped.joins(:channels).merge(current_user.channels).includes(:replys).where(origin_id: nil).order('replys_count DESC').limit(5)
		@likes = Mailinglist.unscoped.joins(:channels).merge(current_user.channels).includes(:replys).where(origin_id: nil).order('likes DESC').limit(5)
	end

	def board
    end

    def subscribe
    	group = Group.find_by_id(params[:id])
    	group.channels.each do |channel|
    		unless current_user.channels.include?(channel)
    			current_user.channels << channel
    		end
    	end

    	redirect_to root_path
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
