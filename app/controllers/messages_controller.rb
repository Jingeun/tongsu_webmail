class MessagesController < ApplicationController
	before_action :authenticate_user!

	def index
		@messages = current_user.messages.where(origin_id: nil)
	end

	def show
		@messages = Array.new
		@message  = Message.find_by_id(params[:id])
		recursive(@messages, @message)
		
		redirect_to root_path unless @message.present?
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
