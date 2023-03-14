require 'csv'
require 'json'

class Api::V1::MoviesController < Api::V1::BaseController
  def index
    @query = params[:query]
    return all_movies if @query.nil?
    return empty_query if @query.empty?

    query_find_it
  end

  def create
    @csv_file = params[:file]
    return empty_csv if @csv_file.nil?
    return diferent_content_file_type if @csv_file.content_type != 'text/csv'
    save_csv
  end

  private

  def all_movies
    movies = Movie.all.sort_by { |key, _value| key['year']}.reverse
    render json: movies, status: 200
  end

  def empty_query
    render json: { error: "You don't send any term to search. Please verify." }, status: 404
  end

  def query_find_it
    movies_search_list = Movie.search_movie(@query)
    movies_search_ordered_list = movies_search_list.sort_by { |key, _value| key['year']}.reverse
    if movies_search_ordered_list.empty?
      render json: { error: "We don't find this term that you are looking for. Please try another." }, status: 404
    else
      render json: movies_search_ordered_list, status: 200
    end
  end

  def empty_csv
    render json: { error: "We don't receive any CSV file. Please check again." }, status: 400
  end

  def diferent_content_file_type
    render json: { error: 'We only accept CSV files. Please check if are sending CSV to us.' }, status: 415
  end

  def save_csv
    CSV.foreach(@csv_file, headers: true) do |row|
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
