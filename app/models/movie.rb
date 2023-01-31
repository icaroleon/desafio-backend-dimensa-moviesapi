class Movie < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_movie, against: %i[title genre year country published_at description]
  
  validates :id, :title, uniqueness: true
  validates :title, :genre, :year, :country, :description, :published_at, presence: true

  def self.search(query)
    movie = Movie.search_movie(query)
    movie.map(&:to_api) # Safe navigation operator. Sends method to an object only if it is not nil
  end

  def self.to_api
    {
      id: @id,
      title: @title,
      genre: @genre,
      year: @year,
      country: @country,
      published_at: @published_at,
      description: @description
    }
  end
end
