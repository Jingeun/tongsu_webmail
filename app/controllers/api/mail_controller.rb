module API
	class MailController < ApplicationController
		include ActionView::Helpers::TextHelper
  		include ActionView::Helpers::UrlHelper
  		include ActionView::Helpers::SanitizeHelper

  		def keyword
  			group = Group.where(name: params[:group]).first
  			group.keywords.create(
  				year: 		params[:year],
  				month: 		params[:month],
  				keyword1: 	params[:keyword1],
  				keyword2: 	params[:keyword2],
  				keyword3: 	params[:keyword3],
  				keyword4: 	params[:keyword4],
  				keyword5: 	params[:keyword5]
  			)

  			head 200
  		end

		def receive
			mail = Mail.read_from_string(params[:mail])

			# Check mail is registered
			if registered?(mail.message_id)

				# Get Receiver
				if params[:import].eql?("true")
					user = User.where(uid: params[:uid]).first
				else
					delivered_to = mail.header['Delivered-To']
					delivered_to = delivered_to.first if delivered_to.class.to_s.eql?('Array')
					uid          = delivered_to.field.value.split('@').first
					user		 = User.where(uid: uid).first
				end

				unless mail.header[:list_post].nil?
					# If mail is mailinglist
					p "DEBUG::MAIL ALREADY REGISTERED MAILINGLIST"
					if params[:import].eql?("true")
						p "DEBUG::MAIL ALREADY IMPORT-MESSAGE : #{mail.subject} #{mail.date}"
					end
					the_mailinglist = Mailinglist.where(message_id: mail.message_id).first

					# Get List-Post
					list_post = mail.header[:list_post].field.value
					list_post = list_post[/\<(.*)>/,1] || list_post
					list_post = list_post.gsub('mailto:', '')

					# Get List-Id
					list_id   = ""
					unless mail.header[:list_id].nil?
						list_id = mail.header[:list_id].field.value
						list_id = list_id[/\<(.*)>/,1] || list_id
					else
						list_id = list_post
					end

					# Check Channel is registered
					channel = Channel.find_by(list_id: list_id)

					unless user.channels.include?(channel)
						user.channels << channel
					end

					keyword_body = ActionController::Base.helpers.strip_tags(the_mailinglist.content)
					keyword_body = keyword_body.gsub('\n', ' ')
					send_msg("#{channel.group.name}_____#{the_mailinglist.date}_____#{keyword_body}")

				else
					p "DEBUG::MAIL ALREADY REGISTERED MESSAGE"
					the_mail = Message.where(message_id: mail.message_id).first

					# Associate to User
					unless user.messages.include?(the_mail)
						user.messages << the_mail
					end
				end

			else
				# If mail isn't registered	

				# Check mail is mailinglist
				unless mail.header[:list_post].nil?
					# If mail is mailinglist

					
					# Get List-Post
					list_post = mail.header[:list_post].field.value
					list_post = list_post[/\<(.*)>/,1] || list_post
					list_post = list_post.gsub('mailto:', '')

					# Get List-Id
					list_id   = ""
					unless mail.header[:list_id].nil?
						list_id = mail.header[:list_id].field.value
						list_id = list_id[/\<(.*)>/,1] || list_id
					else
						list_id = list_post
					end

					# Check Channel is registered
					channel = Channel.find_by(list_id: list_id)
					unless channel.present?
						# If Channel isn't registered
						group_name = list_id.split('@').last.split('.')[-2..-1].join('.')

						if group_name.eql?("apache.org")
							group_name = list_id.split('@').last.split('.')[-3..-1].join('.')
						end

						group = Group.find_by_name(group_name)

						# If Group isn't registered
						unless group.present?
							group = Group.create(name: group_name)
						end

						list_subscribe   = mail.header[:list_subscribe].nil? ? '' : mail.header[:list_subscribe].field.value
						list_unsubscribe = mail.header[:list_unsubscribe].nil? ? '' : mail.header[:list_unsubscribe].field.value
						# Resiger Channel
						channel = group.channels.create(
							name: 				list_post.split('@').first,
							email: 				list_post,
							list_id: 			list_id,
							list_unsubscribe: 	list_unsubscribe,
							list_subscribe: 	list_subscribe,
							list_post: 			list_post
						)
					end

					# Check user is subscribing
					if params[:import].eql?("true")
						user = User.where(uid: params[:uid]).first
					else
						# Get Receiver
						delivered_to = mail.header['Delivered-To']
						delivered_to = delivered_to.first if delivered_to.class.to_s.eql?('Array')
						uid          = delivered_to.field.value.split('@').first
						user		 = User.where(uid: uid).first
					end

					unless user.channels.include?(channel)
						user.channels << channel
					end

					# Check mail is reply
					origin_mail = nil
					in_reply_to = mail.header['In-Reply-To']
					unless in_reply_to.nil?
						in_reply_to = in_reply_to.field.value
						in_reply_to = in_reply_to[/\<(.*)>/,1] || in_reply_to

						# Check origin mails is exist
						if Mailinglist.registered?(in_reply_to)
							origin_mail = Mailinglist.where(message_id: in_reply_to).first
						end
					end

					body = ''
					if mail.multipart?
						unless mail.html_part.nil?
							body = mail.html_part.body.decoded
							doc  = Nokogiri::HTML(body)
							doc  = doc.xpath('//body')
							doc.xpath('.//comment()').remove
							doc.xpath('.//@style').remove
							doc.xpath('.//@mark').remove

							if origin_mail.nil?
								doc.css("blockquote").each do |block|
									block.set_attribute("style", "margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex")
								end
							else
								doc.xpath('.//blockquote').remove
							end
							body = doc.to_s
						else
							body = mail.text_part.body.decoded.gsub(/(?:\n\r?|\r\n?)/, '<br>')
						end
					else
						body = mail.body.decoded.gsub(/(?:\n\r?|\r\n?)/, '<br>')
					end

					# body = body.gsub(/(<br>)+/, '<br>')
					body = auto_link(body.lstrip, :html => { :target => '_blank' }) do |text|
						truncate(text, :length => 100)
					end
					body = body.gsub("  ", "&nbsp; &nbsp;")
					body = body.gsub("<pre>", "<p>")
					body = body.gsub("</pre>", "</p>")

					unless origin_mail.nil?
						arr  = body.split("<br>")
						arr.delete_if { |a| ( a.start_with?("&gt;") or a.start_with?(">") or (a.start_with?("On") and  a.end_with?("wrote:")) ) }
						body = arr.join("<br>")
					end
					# sanitize(body, scrubber: Loofah::Scrubber.new { |node| node.remove if node.name == 'style' })

					reply_to = ''
					if mail.reply_to.nil?
						reply_to = mail.from.join(', ')
					end

					# Save Mailinglist
					mailinglist = Mailinglist.create(
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
					keyword_body = ActionController::Base.helpers.strip_tags(body)
					keyword_body = keyword_body.gsub('\n', ' ')
					send_msg("#{channel.group.name}_____#{mail.date}_____#{keyword_body}")
					if params[:import].eql?("true")
						p "DEBUG::MAIL NEW IMPORT-MESSAGE : #{mail.subject} #{mail.date}"
					end

					# Associate to Channel
					ch_mailing = channel.mailinglists
					unless ch_mailing.include?(mailinglist)
						ch_mailing << mailinglist
					end

					if params[:import].eql?("true")
						mailinglist.channels_mailinglists.where(channel_id: channel).first.update_attributes(is_import: true)
					end

					# Save File Attachments
					unless mail.attachments.empty?
						mail.attachments.each do |attachment|
							attach = mailinglist.attaches.build
							dd = attachment.body.decoded
							attach.content_file_size = dd.bytesize
							attach.content_content_type = attachment.content_type
							attach.content = StringIO.new(dd)
							attach.content_file_name = attachment.filename
							attach.save
						end
					end

					# Associate Origin Mail if reply
					if origin_mail.present?
						origin_mail.replys << mailinglist
						origin_mail.touch
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
						if Message.registered?(in_reply_to)
							origin_mail = Message.where(message_id: in_reply_to).first
						end
					end

					body = ''
					if mail.multipart?
						unless mail.html_part.nil?
							body = mail.html_part.body.decoded
							doc  = Nokogiri::HTML(body)
							doc  = doc.xpath('//body')
							doc.xpath('.//@style').remove
							doc.xpath('.//@mark').remove
							doc.css("blockquote").each do |block|
								block.set_attribute("style", "margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex")
							end
							body = doc.to_s
						else
							body = mail.text_part.body.decoded.gsub(/(?:\n\r?|\r\n?)/, '<br>')
						end
					else
						body = mail.body.decoded.gsub(/(?:\n\r?|\r\n?)/, '<br>')
					end

					
					body = auto_link(body.lstrip, :html => { :target => '_blank' }) do |text|
						truncate(text, :length => 100)
					end
					body = body.gsub("  ", "&nbsp; &nbsp;")

					reply_to = ''
					if mail.reply_to.nil?
						reply_to = mail.from.join(', ')
					end

					# Create Message (Non-Mailinglist Email)
					message = Message.create(
						message_id:  mail.message_id,
						subject: 	 mail.subject,
						content:     body,
						date: 		 mail.date,
						from: 		 mail.from && mail.from.join(', '),
						from_name:   mail.header['From'].addrs.first.display_name,
						to: 		 mail.to && mail.to.join(', '),
						reply_to: 	 reply_to,
						cc: 		 mail.cc && mail.cc.join(', '),
						origin_text: params[:mail]
					)

					if params[:import].eql?("true")
						user = User.where(uid: params[:uid]).first
					else
						# Get Receiver
						delivered_to = mail.header['Delivered-To']
						delivered_to = delivered_to.first if delivered_to.class.to_s.eql?('Array')
						uid          = delivered_to.field.value.split('@').first
						user		 = User.where(uid: uid).first
					end

					# Associate to User
					unless user.messages.include?(message)
						user.messages << message
					end

					if params[:import].eql?("true")
						message.users_messages.where(user_id: user).first.update_attributes(is_import: true)
					else
						notification_path = Rails.application.routes.url_helpers.message_path(message)
						user.notifications.create(
							type: "message",
							url: notification_path,
							description: mail.subject
						)
					end

					# Save File Attachments
					unless mail.attachments.empty?
						mail.attachments.each do |attachment|
							attach = message.attaches.build
							dd = attachment.body.decoded
							attach.content_file_size = dd.bytesize
							attach.content_content_type = attachment.content_type
							attach.content = StringIO.new(dd)
							attach.content_file_name = attachment.filename
							attach.save
						end
					end

					# Save Origin Mail if reply
					if origin_mail.present?
						origin_mail.replys << message
						origin_mail.touch
					end
				end

			end
			head 204
		end

		def download
			send_file params[:url]
		end

		private

		def send_msg(msg)
			require 'bunny'
		    conn = Bunny.new(hostname: "210.118.69.58", vhost: "tongsu-vhost", user: "tongsu", password: "12341234")
		    conn.start

		    ch   = conn.create_channel
		    x    = ch.topic("tongsu")

		    x.publish(msg, persistent: true, routing_key: "From.Web.Keyword.Send")
		    puts "DEBUG::MAIL#SEND_MSG - Send #{msg}"

		    ch.close
		    conn.close
		end
	end
end