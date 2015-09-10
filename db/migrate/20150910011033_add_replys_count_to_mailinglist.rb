class AddReplysCountToMailinglist < ActiveRecord::Migration
  def change
    add_column :mailinglists, :replys_count, :integer, default: 0
  end
end
