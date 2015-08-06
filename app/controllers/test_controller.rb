class TestController < ApplicationController 

	def index
		@test = params[:test]

		if(!ActiveRecord::Base.connection.table_exists?(@test))

			# ActiveRecord::Migration.create_table @test do |t|
			# 	t.string :name
			# end
		end

	end 

end
