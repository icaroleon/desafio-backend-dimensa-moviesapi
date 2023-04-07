require 'csv'
require 'json'

class Api::V1::MoviesController < Api::V1::BaseController
  def index
    query = params[:query]
    return render json: Movie.all_movies if query.nil?
    return render json: { error: "You don't send any term to search. Please verify." }, status: 400 if query.empty?
    return render json: { message: "We don't find any movies with this term. Try another" }, status: 404 if Movie.search(query).empty?

    render json: Movie.search(query)
  end

  def create
    csv_file = params[:file]

    return render json: { error: "We don't receive any CSV file. Please check again." }, status: 400 if csv_file.nil?

    return render json: { error: "We only accept CSV files. Please check if are sending CSV to us." }, status: 415 if csv_file.content_type != "text/csv"

    render json: Movie.save(csv_file)
  end
end
