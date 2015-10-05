class AddLikesToMailinglist < ActiveRecord::Migration
  def change
    add_column :mailinglists, :likes, :integer, default: 0
  end
end
