class MailinglistsController < ApplicationController
	before_action :authenticate_user!, only: [:index, :show]
	before_action :get_not_read_message, only: [:index, :show]
	before_action :get_groups, only: [:show]
	before_action :get_mailinglist, only: [:see_more, :get_comments]

	$temp_date    = nil
    $color_index  = 0

	def index
	end

	def show
		@channel = Channel.find_by_id(params[:id])

		# If channel non-exists
		unless @channel.present?
			redirect_to root_path 
			return
		end

		# Check authentication
		if current_user.channels.include?(@channel)
			@mailinglists = @channel.mailinglists.where(origin_id: nil).paginate(page: params[:page], per_page: 10)		
			respond_to do |format|
				format.html do 
					$temp_date    = nil
    				$color_index  = 0
				end
				format.js
			end
		else
			redirect_to root_path
		end
	end

	def see_more
		respond_to do |format|
			format.js
		end
	end

	def get_comments
		@replys = Array.new
		recursive(@replys, @message)
		@replys.shift
		@replys = @replys.reverse

		respond_to do |format|
			format.js
		end
	end

	protected

	def get_mailinglist
		@message = Mailinglist.find_by_id(params[:id])
	end

	def recursive(messages, message)
		messages << message

		unless message.replys.present?
			return
		end

		message.replys.each do |reply|
			recursive(messages, reply)
		end
	end
	helper_method :recursive
end
