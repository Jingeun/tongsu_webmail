class AddImportToUsersMessages < ActiveRecord::Migration
  def change
    add_column :users_messages, :is_import, :boolean, default: false
  end
end
