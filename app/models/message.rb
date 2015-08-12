class Message < ActiveRecord::Base
  default_scope -> { order('updated_at DESC') }
  
  # User & Message N:M Association
  has_many :users_messages
  has_many :user, through: "users_messages"

  has_many :replys, foreign_key: "origin_id", class_name: "Message"
  belongs_to :origin, class_name: "Message"

  def self.registered?(message_id)
  	if self.where(message_id: message_id).present?
  		true
  	else
  		false
  	end
  end
end
