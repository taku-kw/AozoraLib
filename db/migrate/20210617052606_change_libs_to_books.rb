class ChangeLibsToBooks < ActiveRecord::Migration[6.1]
  def change
    rename_table :libs, :books
  end
end

