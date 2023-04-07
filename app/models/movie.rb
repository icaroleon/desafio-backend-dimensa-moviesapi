class Movie < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_movie, against: %i[title genre year country published_at description]
  validates :id, :title, uniqueness: true
  validates :title, :genre, :year, :country, :description, :published_at, presence: true

  def self.to_api(movie)
    {
      id: movie.id,
      title: movie.title,
      genre: movie.genre,
      year: movie.year,
      country: movie.country,
      published_at: movie.published_at,
      description: movie.description
    }
  end

  ### Index

  def self.all_movies
    Movie.all.order(year: :desc)
  end

  def self.search(query)
    movies_search_list = Movie.search_movie(query)
    movies_search_ordered_list = movies_search_list.order(year: :desc)

    movies_search_ordered_list.map(&:to_api)
  end

  ### Create

  def self.save(csv_file)
    CSV.foreach(csv_file, headers: true) do |row|
      Movie.create({
                      title: row['title'],
                      genre: row['type'],
                      year: row['release_year'],
                      country: row['country'],
                      published_at: row['date_added'],
                      description: row['description']
                  })
    end
    { message: "Movies successfully imported." }
  end
end
