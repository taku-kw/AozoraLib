class AddColumnBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :release_date, :date
  end
end
