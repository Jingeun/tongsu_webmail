class CreateUsersChannels < ActiveRecord::Migration
  def change
    create_table :users_channels do |t|
    	t.references :user
    	t.references :channel
    	t.timestamps null: false
    end
  end
end
