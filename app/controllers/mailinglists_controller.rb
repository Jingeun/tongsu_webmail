class MailinglistsController < ApplicationController
	before_action :authenticate_user!, only: [:index, :show]
	before_action :get_not_read_message, only: [:index, :show]
	before_action :get_groups, only: [:show]

	def index
	end

	def show
		@channel = Channel.find_by_id(params[:id])
		if current_user.channels.include?(@channel)
			@mailinglists = @channel.mailinglists.where(origin_id: nil)
		else
			redirect_to root_path
		end
	end
end
