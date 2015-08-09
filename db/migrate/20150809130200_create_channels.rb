class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.references :group, index: true
      t.string :name,   null: false, defualt: ""
      t.string :email,  null: false, defualt: ""
      t.string :list_id
      t.string :list_unsubscribe
      t.string :list_subscribe
      t.string :list_post
      t.string :list_help

      t.timestamps null: false
    end
    add_index :users, :email,                  unique: true
    add_foreign_key :channels, :groups
  end
end
