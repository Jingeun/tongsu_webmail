class MessagesController < ApplicationController
	before_action :authenticate_user!
	before_action :get_not_read_messaged, only: [:index, :show]

	def index
		# Show only origin messages
		@messages = current_user.messages.where(origin_id: nil)
	end

	def show
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
			m.users_messages.where(user_id: current_user).first.update_columns(is_read: true)
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
