class CreateOpenstackDevs < ActiveRecord::Migration
  def change
    create_table :openstack_devs do |t|
    		t.string :from
    		t.string :to
    		t.string :subject
    		t.string :body
    		t.date :date
    		t.string :file
    		t.timestamps null: false
    end
  end
end