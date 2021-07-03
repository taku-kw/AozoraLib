class CreateRecommendAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :recommend_authors do |t|
      t.text :author, null: false
      t.boolean :valid, default: true, null: false

      t.timestamps
    end
  end
end
