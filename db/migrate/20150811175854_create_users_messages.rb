class CreateUsersMessages < ActiveRecord::Migration
  def change
    create_table :users_messages do |t|
      t.references :user, index: true
      t.references :message, index: true
      t.boolean    :is_read, default: false
      t.boolean    :is_favorite, default: false
      t.timestamps null: false
    end
    add_foreign_key :users_messages, :users
    add_foreign_key :users_messages, :messages
  end
end
