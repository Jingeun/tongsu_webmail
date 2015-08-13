class AddAttachmentContentToAttaches < ActiveRecord::Migration
  def self.up
    change_table :attaches do |t|
      t.attachment :content
    end
  end

  def self.down
    remove_attachment :attaches, :content
  end
end
