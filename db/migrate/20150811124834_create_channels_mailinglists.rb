class CreateChannelsMailinglists < ActiveRecord::Migration
  def change
    create_table :channels_mailinglists do |t|
      t.references :channel, index: true
      t.references :mailinglist, index: true
      t.timestamps null: false
    end
    add_foreign_key :channels_mailinglists, :channels
    add_foreign_key :channels_mailinglists, :mailinglists
  end
end
