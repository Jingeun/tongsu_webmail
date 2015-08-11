module API
	class MailController < ApplicationController
		def receive
			mail = Mail.read_from_string(params[:mail])
			head 204
		end
	end
end