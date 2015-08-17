class CreateMailinglists < ActiveRecord::Migration
  def change
    create_table :mailinglists do |t|
      t.integer :origin_id
      t.string :message_id
      t.string :subject
      t.text :content, :limit => 4294967295
      t.datetime :date
      t.string :from
      t.string :from_name
      t.string :to
      t.string :reply_to
      t.string :cc
      t.string :bcc
      t.string :mime_version
      t.text   :origin_text, :limit => 4294967295

      t.timestamps null: false
    end
    add_index :mailinglists, :message_id, unique: true
  end
end
