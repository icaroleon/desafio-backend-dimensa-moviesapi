class Movie < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_movie, against: %i[title genre year country published_at description], order_within_rank: "year DESC"
  validates :id, :title, uniqueness: true
  validates :title, :genre, :year, :country, :description, :published_at, presence: true
  paginates_per 10

  def to_api
    {
      id: id,
      title: title,
      year: year,
      genre: genre,
      country: country,
      published_at: published_at,
      description: description
    }
  end

  ### Index

  def self.all_movies(page)
    Movie.all.order(year: :desc, title: :asc).page(page).map(&:to_api)
    # Ao ser utilizada a expressão "&:" juntamente com o metódo Map, o bloco "to_api" é passado como argumento.
  end

  def self.search(query, page = nil)
    movies_search_list = Movie.search_movie(query).page(page)

    movies_search_list.map(&:to_api)
    # Ao ser utilizada a expressão "&:" juntamente com o metódo Map, o bloco "to_api" é passado como argumento.
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
