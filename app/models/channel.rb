class Channel < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: "users_channels", class_name: "User"
  belongs_to :group

  validates :name ,presence: true
  validates :email ,presence: true
end
