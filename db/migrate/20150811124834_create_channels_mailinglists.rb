class CreateChannelsMailinglists < ActiveRecord::Migration
  def change
    create_table :channels_mailinglists do |t|
      t.references :channel, index: true
      t.references :mailinglist, index: true
      t.boolean    :is_read, default: false
      t.boolean    :is_favorite, default: false
      t.timestamps null: false
    end
    add_foreign_key :channels_mailinglists, :channels
    add_foreign_key :channels_mailinglists, :mailinglists
  end
end
