class Message < ActiveRecord::Base
  belongs_to :user
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
