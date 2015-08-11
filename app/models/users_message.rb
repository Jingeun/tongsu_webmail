class UsersMessage < ActiveRecord::Base
  # User & Message N:M Association
  belongs_to :user
  belongs_to :message
end
