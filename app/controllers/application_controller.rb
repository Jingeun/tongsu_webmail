class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception. 
	# For APIs, you may want to use :null_session instead.
	# protect_from_forgery with: :exception
	before_filter :configure_permitted_parameters, if: :devise_controller?
	before_action :header

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) << :user_id << :name << :sex << :email << :phone
		devise_parameter_sanitizer.for(:sign_in) << :user_id
	end

	
	def header
		@mailing = current_user && current_user.matchings
	end
end