module API
	class CheckController < ApplicationController
		def registered
			if registered?(params[:message_id])
				head 204
			else
				head 404
			end
		end

		def mailinglist
		end

		private

		def registered?(message_id)
			if Mailinglist.registered?(message_id) || Message.registered?(message_id)
				true
			else
				false
			end
		end
	end
end