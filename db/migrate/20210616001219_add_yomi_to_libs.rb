class AddYomiToLibs < ActiveRecord::Migration[6.1]
  def change
    add_column :libs, :title_yomi, :string
    add_column :libs, :author_yomi, :string
  end
end
