require 'csv'
require 'json'

class Api::V1::MoviesController < Api::V1::BaseController
  def index
    query = params[:query]
    return render json: Movie.all_movies if query.nil?
    return render json: { error: "You don't send any term to search. Please verify." }, status: 404 if query.empty?

    render json: Movie.search(query)
  end

  def create
    csv_file = params[:file]

    return render json: { error: "We don't receive any CSV file. Please check again." }, status: 400 if csv_file.nil?

    return render json: { error: "We only accept CSV files. Please check if are sending CSV to us." }, status: 415 if csv_file.content_type != "text/csv"

    Movie.save(csv_file)
    render json: { successful: "We just saved the CSV that you send to us. Thank you." }, status: 200
  end
end
