class MessagesController < ApplicationController
	before_action :authenticate_user!
	before_action :get_not_read_message, except: [:show, :original]
	before_action :get_groups, except: [:original, :create]

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
		@message = current_user.sent_messages.new
	end

	def create
		mail = Mail.new do
		  from    '#{current_user.uid}@tongsu.tk'
		  to      '#{params[:sent_message][:to]}'
		  subject '#{params[:sent_message][:subject]}'
		  body    '#{params[:sent_message][:content]}'
		end

		p "DEBUG::MESSAGES #{mail}"
		send_msg(mail)

		redirect_to messages_path
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

	private

	def send_msg(msg)
		require 'bunny'
	    conn = Bunny.new(hostname: "210.118.69.58", vhost: "tongsu-vhost", user: "tongsu", password: "12341234")
	    conn.start

	    ch   = conn.create_channel
	    x    = ch.topic("tongsu")

	    x.publish(msg, persistent: true, routing_key: "From.Web.Send.Mail")
	    puts "DEBUG::MESSAGES#SEND_MSG - Send #{msg}"

	    ch.close
	    conn.close
	end
end
