class MailsController < ApplicationController
	before_action :authenticate_user!
	before_action :get_not_read_message
	before_action :get_groups

	def show
	end
end
