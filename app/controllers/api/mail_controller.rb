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
				if (!mail.header[:list_id].nil?) || (!mail.header[:list_post].nil?)
					# If mail is mailinglist

					# Get List-Id
					list_id   = ""
					list_post = ""
					unless mail.header[:list_id].nil?
						list_id = mail.header[:list_id].field.value
						list_id = list_id[/\<(.*)>/,1] || list_id
					else
						list_post = mail.header[:list_post].field.value
						list_post = list_post[/\<(.*)>/,1] || list_post
						list_post.gsub('mailto:', '')
						list_id = list_post
					end

					# Check Channel is registered
					channel = Channel.find_by(list_id: list_id)
					unless channel.present?
						# If Channel isn't registered
						group_name = list_id.split('@').last.split('.')[-2..-1].join('.')
						group = Group.find_by_name(group_name)

						# If Group isn't registered
						unless group.prersent?
							group = Group.create(name: group_name)
						end

						# Resiger Channel
						channel = group.channels.create(
							name: 				list_post.split('@').first,
							email: 				list_post,
							list_id: 			list_id,
							list_unsubscribe: 	mail.header[:list_unsubscribe].field.value,
							list_subscribe: 	mail.header[:list_subscribe].field.value,
							list_post: 			mail.header[:list_post].field.value
						)
					end

					# Check user is subscribing
					delivered_to = mail.header['Delivered-To']
					delivered_to = delivered_to.first if delivered_to.class.eql?('Array')
					uid          = delivered_to.field.value.split('@').first
					user		 = User.where(uid: uid).first

					unless user.channels.include?(channel)
						user.channels << channel
					end

					# Check mail is reply
					in_reply_to = mail.header['In-Reply-To']
					unless in_reply_to.nil?
						in_reply_to = in_reply_to.field.value
						in_reply_to = in_reply_to[/\<(.*)>/,1] || in_reply_to

						# Check origin mails is exist && is mailinglist
						if registered?(in_reply_to) && ((!mail.header[:list_id].nil?) || (!mail.header[:list_post]))
							# Remove origin from mail
							# TODO
						end
					end

				else
					# If mail isn't mailinglist

					# Check mail is reply
					origin_mail = nil
					in_reply_to = mail.header['In-Reply-To']
					unless in_reply_to.nil?
						in_reply_to = in_reply_to.field.value
						in_reply_to = in_reply_to[/\<(.*)>/,1] || in_reply_to

						
						# Check origin mails is exist
						if registered?(in_reply_to)
							origin_mail = Message.where(message_id: in_reply_to).first
						end
					end

					body = ''
					if mail.multipart?
						if mail.attachments.empty?
							body = mail.parts.last.body.decoded
						else
							body = mail.parts.first.body.parts.last.body.decoded
						end
					else
						body = mail.body.decoded
					end

					reply_to = ''
					if mail.reply_to.nil?
						reply_to = mail.from.join(', ')
					end

					message = Message.create(
						message_id:  mail.message_id,
						subject: 	 mail.subject,
						content:     body,
						date: 		 mail.date,
						from: 		 mail.from.join(', '),
						from_name:   mail.header['From'].addrs.first.display_name,
						to: 		 mail.to.join(', '),
						reply_to: 	 reply_to,
						cc: 		 mail.cc && mail.cc.join(', '),
						origin_text: params[:mail]
					)

					delivered_to = mail.header['Delivered-To']
					delivered_to = delivered_to.first if delivered_to.class.eql?('Array')
					uid          = delivered_to.field.value.split('@').first
					user		 = User.where(uid: uid).first

					unless user.messages.include?(message)
						user.messages << message
					end

					if origin_mail.present?
						origin_mail.replys << message
					end
				end

				


			end
			head 204
		end
	end
end