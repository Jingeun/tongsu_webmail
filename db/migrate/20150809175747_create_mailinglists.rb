class CreateMailinglists < ActiveRecord::Migration
  def change
    create_table :mailinglists do |t|
      t.references :channel, index: true
      t.integer :origin_id
      t.string :message_id
      t.string :subject
      t.text :content
      t.datetime :date
      t.string :from
      t.string :to
      t.string :reply_to
      t.string :cc
      t.string :bcc
      t.string :mime_version

      t.timestamps null: false
    end
    add_foreign_key :mailinglists, :channels
    add_index :mailinglists, :message_id, unique: true
    add_index :mailinglists, :subject, unique: true
  end
end
