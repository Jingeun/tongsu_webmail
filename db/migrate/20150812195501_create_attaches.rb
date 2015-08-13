class CreateAttaches < ActiveRecord::Migration
  def change
    create_table :attaches do |t|
      t.integer :attachable_id
      t.string  :attachable_type
      t.timestamps null: false
    end
  end
end
