class MessagesController < ApplicationController
	before_action :authenticate_user!
	before_action :get_not_read_message, except: :show

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

		get_not_read_message
	end

	def new
		@current_users_messages = current_user.messages

		# FORM FOR MAIL CREATE
		# TODO
	end

	def original
		@message = current_user.messages.find(params[:id])

		# If Message non-exists
		unless @message.present?
			redirect_to root_path 
			return
		else
			render layout: false
		end
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
