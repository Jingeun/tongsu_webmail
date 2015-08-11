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
				if (!mail.header[:list_id].nil?) || (!mail.header[:list_post])
					# If mail is mailinglist

					# Get List-Id
					list_id = ""
					unless mail.header[:list_id].nil?
						list_id = mail.header[:list_id].field.value
						list_id = list_id[/\<(.*)>/,1] || list_id
					else
						list_id = mail.header[:list_post].field.value
						list_id = list_id[/\<(.*)>/,1] || list_id
						list_id.gsub('mailto:', '')
					end

					# Check Channel is registered
					if Mailinglist.find_by(list_id: list_id).present?

					else
						# Check Group is registered
						group_name = list_id.split('@').last.split('.')[-2..-1].join('.')
						if Group.find_by_name(group_name).prersent?
						else
						end
					end

				else
					# If mail isn't mailinglist
				end
			end
			head 204
		end
	end
end