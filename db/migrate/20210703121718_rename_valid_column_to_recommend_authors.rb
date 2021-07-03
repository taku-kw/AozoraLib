class RenameValidColumnToRecommendAuthors < ActiveRecord::Migration[6.1]
  def change
    rename_column :recommend_authors, :valid, :rec_valid
  end  
end
