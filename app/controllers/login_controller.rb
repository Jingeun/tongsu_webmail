class LoginController < ApplicationController
	def id_check
		id = params["user_id"]
			#@availabe = false
		check = User.find_by_user_id(id)
		
		if check.nil?
			head 204
		else
			head 404
		end
	end
end
