class MailinglistsController < ApplicationController
	before_action :authenticate_user!, only: [:index]
	before_action :get_not_read_message, only: [:index]

	def index
	end
end
