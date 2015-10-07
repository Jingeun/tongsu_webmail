class Group < ActiveRecord::Base
	validates :name ,presence: true
	has_many :channels, dependent: :destroy
	has_many :keywords, dependent: :destroy
end
