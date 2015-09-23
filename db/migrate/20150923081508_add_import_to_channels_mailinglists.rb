class AddImportToChannelsMailinglists < ActiveRecord::Migration
  def change
    add_column :channels_mailinglists, :is_import, :boolean, default: false
  end
end
