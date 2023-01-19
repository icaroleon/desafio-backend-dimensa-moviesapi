class CreateMoviesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :movies, id: :uuid do |t|
      t.timestamps
    end
  end
end
