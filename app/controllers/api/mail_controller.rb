module API
	class MailController < ApplicationController
		include ActionView::Helpers::TextHelper
  		include ActionView::Helpers::UrlHelper
  		include ActionView::Helpers::SanitizeHelper

		def receive
			mail = Mail.read_from_string(params[:mail])

			# Check mail is registered
			if registered?(mail.message_id)

				unless mail.header[:list_post].nil?
					# If mail is mailinglist

				else
					p "DEBUG::MAIL ALREADY REGISTERED MESSAGE"
					the_mail = Message.where(message_id: mail.message_id).first

					p "DEBUG::MAIL #{the_mail.subject}"
					# Get Receiver
					delivered_to = mail.header['Delivered-To']
					delivered_to = delivered_to.first if delivered_to.class.to_s.eql?('Array')
					uid          = delivered_to.field.value.split('@').first
					user		 = User.where(uid: uid).first

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

					p "DEBUG::MAIL List-Id:#{list_id}"
					p "DEBUG::MAIL List-Post:#{list_post}"

					# Check Channel is registered
					channel = Channel.find_by(list_id: list_id)
					unless channel.present?
						p "DEBUG::MAIL Channel isn't registered."
						# If Channel isn't registered
						group_name = list_id.split('@').last.split('.')[-2..-1].join('.')

						if group_name.eql?("apache.org")
							group_name = list_id.split('@').last.split('.')[-3..-1].join('.')
						end

						group = Group.find_by_name(group_name)
						p "DEBUG::MAIL Find gruop name : #{group_name}"

						# If Group isn't registered
						unless group.present?
							p "DEBUG::MAIL Group isn't registered."
							group = Group.create(name: group_name)
							p "DEBUG::MAIL Create group : #{group.name}"
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
					delivered_to = mail.header['Delivered-To']
					delivered_to = delivered_to.first if delivered_to.class.to_s.eql?('Array')
					uid          = delivered_to.field.value.split('@').first
					user		 = User.where(uid: uid).first
					p "DEBUG::MAIL Check user subscribing : #{uid}"

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

					send_msg("#{channel.name}_____#{mail.date}_____#{sanitize(body)}")

					# Associate to Channel
					ch_mailing = channel.mailinglists
					unless ch_mailing.include?(mailinglist)
						ch_mailing << mailinglist
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
						from: 		 mail.from.join(', '),
						from_name:   mail.header['From'].addrs.first.display_name,
						to: 		 mail.to.join(', '),
						reply_to: 	 reply_to,
						cc: 		 mail.cc && mail.cc.join(', '),
						origin_text: params[:mail]
					)

					# Get Receiver
					delivered_to = mail.header['Delivered-To']
					delivered_to = delivered_to.first if delivered_to.class.to_s.eql?('Array')
					uid          = delivered_to.field.value.split('@').first
					user		 = User.where(uid: uid).first

					# Associate to User
					unless user.messages.include?(message)
						user.messages << message
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