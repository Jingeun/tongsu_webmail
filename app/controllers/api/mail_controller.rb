module API
	class MailController < ApplicationController
		def receive
			puts params
		end
	end
end