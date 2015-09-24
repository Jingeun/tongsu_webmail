class Import < ActiveRecord::Base
  belongs_to :user

	validates :mailtype ,presence: true
	validates :email ,presence: true, uniqueness: { case_sensitive: false }
	validates :password ,presence: true
end
