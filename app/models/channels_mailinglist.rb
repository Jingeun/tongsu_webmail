class ChannelsMailinglist < ActiveRecord::Base
  # Channel & Mailinglist N:M Association
  belongs_to :channel
  belongs_to :mailinglist
end
