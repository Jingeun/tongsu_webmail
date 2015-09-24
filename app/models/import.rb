class Import < ActiveRecord::Base
  belongs_to :user

	validates :type ,presence: true
	validates :email ,presence: true, uniqueness: { case_sensitive: false }
	validates :password ,presence: true
end
