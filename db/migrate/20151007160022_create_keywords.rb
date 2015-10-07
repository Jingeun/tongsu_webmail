class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.references :group, index: true
      t.integer :year
      t.integer :month
      t.string :keyword1
      t.string :keyword2
      t.string :keyword3
      t.string :keyword4
      t.string :keyword5

      t.timestamps null: false
    end
    add_foreign_key :keywords, :groups
  end
end
