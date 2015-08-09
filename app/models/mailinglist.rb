class Mailinglist < ActiveRecord::Base
  belongs_to :channel
  has_many :replys, foreign_key: "origin_id", class_name: "Mailinglist"
  belongs_to :origin, class_name: "Mailinglist"

  def self.registered?(message_id)
  	if self.where(message_id: message_id).present?
  		true
  	else
  		false
  	end
  end
end
