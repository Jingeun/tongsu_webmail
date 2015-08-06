class CreateMatchings < ActiveRecord::Migration
  def change
    create_table :matchings do |t|
    		t.integer :user_id
  		t.string :mail
      t.timestamps null: false
    end
  end
end
