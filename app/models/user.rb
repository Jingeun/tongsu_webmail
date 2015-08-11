class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise  :database_authenticatable, :registerable,
			:recoverable, :rememberable, :trackable, :validatable

	has_and_belongs_to_many :channels, join_table: "users_channels", class_name: "Channel"

	# User & Message N:M Association
	has_many :messages, through: "users_messages"
	has_many :users_messages

	validates :uid, presence: true, uniqueness: { case_sensitive: false }
	validates :name ,presence: true
end
