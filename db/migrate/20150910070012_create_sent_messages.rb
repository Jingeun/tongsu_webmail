class CreateSentMessages < ActiveRecord::Migration
  def change
    create_table :sent_messages do |t|
      t.string :from
      t.string :to
      t.string :from_name
      t.string :subject
      t.text :content
      t.references :user

      t.timestamps null: false
    end
  end
end
