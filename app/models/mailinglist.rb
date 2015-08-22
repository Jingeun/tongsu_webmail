class Mailinglist < ActiveRecord::Base
  default_scope -> { order('updated_at DESC') }
  # File attachment
  has_many :attaches, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attaches

  # Channel & Mailinglist N:M Association
  has_many :channels_mailinglists
  has_many :channels, through: "channels_mailinglists"

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
