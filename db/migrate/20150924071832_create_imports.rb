class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :mailtype
      t.string :email
      t.string :password
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :imports, :users
  end
end
