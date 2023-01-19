class AddRowsToMoviesTable < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :title, :string
    add_column :movies, :genre, :string
    add_column :movies, :year, :integer
    add_column :movies, :country, :string
    add_column :movies, :description, :text
    add_column :movies, :published_at, :date
  end
end
