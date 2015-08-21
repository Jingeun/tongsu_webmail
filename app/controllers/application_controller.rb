class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception. 
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :null_session
	before_filter :configure_permitted_parameters, if: :devise_controller?

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) << :uid << :name << :email
		devise_parameter_sanitizer.for(:sign_in) << :uid
	end

	def registered?(message_id)
		if Mailinglist.registered?(message_id) || Message.registered?(message_id)
			true
		else
			false
		end
	end

	def get_not_read_message
		# Count Not read messages
		@not_read = current_user.users_messages.where(is_read: false).count
	end

	def get_groups
		@groups = Group.joins(:channels).merge(current_user.channels).uniq
	end
end