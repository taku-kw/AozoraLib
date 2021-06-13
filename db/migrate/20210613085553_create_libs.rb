class CreateLibs < ActiveRecord::Migration[6.1]
  def change
    create_table :libs do |t|
      t.text :title
      t.text :author
      t.text :class_number
      t.text :link

      t.timestamps
    end
  end
end
