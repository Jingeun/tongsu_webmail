module API
	class MailController < ApplicationController
		def receive
			mail = Mail.read_from_string(params[:mail])

			# Check mail is registered
			if registered?(mail.message_id)
				# If mail is registered

			else
				# If mail isn't registered	

				# Check mail is mailinglist
				if (!mail.header[:list_id].nil?) || (!mail.header[:list_subsribe]) || (!mail.header[:list_unsubsribe]) || (!mail.header[:list_help])
					# If mail is mailinglist

				else
					# If mail isn't mailinglist
				end
			end
			head 204
		end
	end
end