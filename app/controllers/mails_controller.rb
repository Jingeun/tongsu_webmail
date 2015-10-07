class MailsController < ApplicationController
	before_action :authenticate_user!
	before_action :get_not_read_message
	before_action :get_groups

	def show
		@channel = Channel.find_by_id(params[:mailinglist_id])
		@message = @channel.mailinglists.where(id: params[:id]).first

		@messages = Array.new

		# If Message non-exists
		unless @message.present?
			redirect_to root_path 
			return
		end

		# Find all Replys
		recursive(@messages, @message)
	end

	private

	def recursive(messages, message)
		messages << message

		unless message.replys.present?
			return
		end

		message.replys.each do |reply|
			recursive(messages, reply)
		end
	end
end
