module API
	class MailController < ApplicationController
		def receive
			puts "DEBUG::PARAMS: #{params}"
			head 204
		end
	end
end