class MailinglistsController < ApplicationController
	before_action :authenticate_user!, only: [:index, :show]
	before_action :get_not_read_message, only: [:index, :show]
	before_action :get_groups, only: [:show]
	before_action :get_mailinglist, only: [:see_more, :get_comments, :likes]

	$temp_date    = nil
    $color_index  = 0

	def index
	end

	def show
		@uid      = current_user.uid
		@channel  = Channel.find_by_id(params[:id])
		date_time = DateTime.now
		@keywords = @channel.group.keywords.where(year: date_time.year, month: date_time.month).first

		# If channel non-exists
		unless @channel.present?
			redirect_to root_path 
			return
		end

		# Check authentication
		if current_user.channels.include?(@channel)
			if params[:search].present?
				@mailinglists = @channel.mailinglists.where("lower(subject) LIKE ? or lower(content) LIKE ?", "%#{params[:search].downcase}%", "%#{params[:search].downcase}%").paginate(page: params[:page], per_page: 10)		
			else
				@mailinglists = @channel.mailinglists.where(origin_id: nil).paginate(page: params[:page], per_page: 10)		
			end
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
		@replys = @replys.sort

		respond_to do |format|
			format.js
		end
	end

	def create_comments
		@uid     = current_user.uid
		channel  = Channel.find_by_id(params[:id])
		@message = Mailinglist.find_by_id(params[:message_id])
		@mail = channel.mailinglists.create(
			content:     params[:content],
			from: 		 "#{current_user.uid}@tongsu.tk",
			from_name:   current_user.uid,
		)
		@message.replys << @mail

		p "DEBUG::MAILINGLIST#CREATE_COMMENTS #{@mail.content}"

		respond_to do |format|
			format.js
		end
	end

	def likes
		channel = Channel.find_by_id(params[:channel])
		temp    = @message.channels_mailinglists.where(channel_id: channel).first
		@is_add = false
		if temp.is_favorite
			temp.update_attributes(is_favorite: false)
			@message.update_attributes(likes: @message.likes-1)
			@is_add = false
		else
			temp.update_attributes(is_favorite: true)
			@message.update_attributes(likes: @message.likes+1)
			@is_add = true
		end

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
