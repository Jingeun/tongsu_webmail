class TimelinesController < ApplicationController
	def index
		@timeline = params[:mailing_target]
	end
end