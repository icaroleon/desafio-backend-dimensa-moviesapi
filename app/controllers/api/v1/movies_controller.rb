#movies Controller

require 'csv'
require 'json'

class Api::V1::MoviesController < Api::V1::BaseController
  def index
    query = params[:query]
    @movies = Movie.all
    if query.nil?
      render json: @movies
    elsif query.empty?
      render json: { error: "You don't send any term to search. Please verify." }, status: 404
    else
      movies_search_list = Movie.search_movie(query) 
      movies_search_ordered_list = movies_search_list.sort_by {|key, value| key["year"]}.reverse
    if movies_search_ordered_list.empty?
      render json: { error: "We don't find this term that you are looking for. Please try another." }, :status => 404
    else
      render json: { results: movies_search_ordered_list }, status: 200
    end
    end
  end

  def create
    csv_file = params[:file]
    if csv_file.nil?
      render json: { error: "We don't receive any CSV file. Please check again." }, status: 400
    elsif csv_file.content_type != 'text/csv'
      render json: { error: 'We only accept CSV files. Please check if are sending CSV to us.' }, status: 415
    else
      CSV.foreach(csv_file, headers: true) do |row|
        Movie.create({  
          title: row['title'],
          genre: row['type'],
          year: row['release_year'],
          country: row['country'],
          published_at: row['date_added'],
          description: row['description'] })
      end
      render json: { successful: 'We just saved the CSV that you send to us. Thank you.' }, status: 200
    end
  end
end
