class MessagesController < ApplicationController
	before_action :authenticate_user!

	def index
		@messages = current_user.messages
		@origin_messages = @messages.where(origin_id: nil)
	end

	def show
		@current_users_messages = current_user.messages
		@messages = Array.new
		@message  = Message.find_by_id(params[:id])

		# If Message non-exists
		unless @message.present?
			redirect_to root_path 
			return
		end

		# Find all Replys
		recursive(@messages, @message)
		@messages.each do |m|
			m.update_columns(is_read: true)
		end
	end

	def new
		@current_users_messages = current_user.messages

		# FORM FOR MAIL CREATE
		# TODO
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
