require 'csv'
require 'json'

class Api::V1::MoviesController < Api::V1::BaseController
  # The 'index' function receives the GET requests and renders responses.
  def index
    query = params[:query]
    page = params[:page]

    return render json: Movie.all_movies(page), status: 200 if query.nil?
    return render json: { message: "The query that you send it was empty. Please verify." }, status: 400 if query.empty?
    return render json: { message: "We don't find any movies with the term '#{query}'. Try another" }, status: 404 if Movie.search(query).empty?

    render json: Movie.search(query, page)
  end

  # The 'create' method receives a POST request with a CSV file to save in the database.
  def create
    csv_file = params[:file]

    return render json: { error: "We didn't receive any CSV file. Please check again." }, status: 400 if csv_file.nil?
    return render json: { error: "We only accept CSV files. Please verify the file type." }, status: 415 if csv_file.content_type != "text/csv"

    # Calls the 'save' method of the Movie class and returns a JSON response.
    render json: Movie.save(csv_file)
  end
end
