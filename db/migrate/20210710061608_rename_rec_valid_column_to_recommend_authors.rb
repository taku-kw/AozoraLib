class RenameRecValidColumnToRecommendAuthors < ActiveRecord::Migration[6.1]
  def change
    rename_column :recommend_authors, :rec_valid, :can_webapi
  end
end
