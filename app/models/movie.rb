class Movie < ApplicationRecord
  include PgSearch::Model
  
  # Configuring search scope using pg_search gem.
  pg_search_scope :search_movie, against: %i[title genre year country published_at description], 
    using: { tsearch: { prefix: :true } }, order_within_rank: "year DESC"

  validates :id, :title, uniqueness: true 
  validates :title, :genre, :year, :country, :description, :published_at, presence: true 
  paginates_per 10 

  def to_api
    # Transform movie object into the required format.
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
    # Returns a paginated list of all movies sorted by release year and title.
    Movie.all.order(year: :desc, title: :asc).page(page).map(&:to_api) 
  end

  def self.search(query, page = nil)
    # Returns a paginated list of movies that contain the 'query' term in the request.
    movies_search_list = Movie.search_movie(query).page(page)
    movies_search_list.map(&:to_api)
  end

  ### Create

  def self.save(csv_file)
    # Import a CSV file containing movie information and save it to the database.
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
