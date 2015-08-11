module API
	class CheckController < ApplicationController
		def registered
			if registered?(params[:message_id])
				head 204
			else
				head 404
			end
		end
	end
end