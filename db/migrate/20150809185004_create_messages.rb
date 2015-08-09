class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true
      t.integer :reply_id
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
    add_foreign_key :messages, :users
    add_index :messages, :message_id, unique: true
    add_index :messages, :subject, unique: true
  end
end
