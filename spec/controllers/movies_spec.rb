require "rails_helper"
require "rspec/expectations"
require "debug"

RSpec.describe Api::V1::MoviesController, type: :controller do
  describe "GET /api/v1/movies" do
    before(:each) do
      FactoryBot.create(:movie)
      FactoryBot.create(:movie2)
    end

    it "returns movies that matches the query" do
      get :index, params: { query: "Brasil" }
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response.body).to include("Central do Brasil")
    end

    it "returns error when no movie found" do
      query = 'La casa de Papel'
      get :index, params: { query: query }
      expect(response).to have_http_status(404)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response.body).to include("We don't find any movies with the term '#{query}'. Try another")
    end

    it "returns error when the query is empty" do
      get :index, params: { query: "" }
      expect(response).to have_http_status(400)
      expect(response.body).to include("The query that you send it was empty. Please verify.")
    end

    it "returns all movies if no parameters are sent" do
      get :index, params: {}
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body).size).to eq(Movie.all.count)
    end
  end

  describe "POST /api/v1/movies" do
    it "returns error when no file is sent" do
      post :create, params: { csv_file: nil }
      expect(response).to have_http_status(400)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response.body).to include("We didn't receive any CSV file. Please check again.")
    end

    it "returns error when file is not CSV" do
      other_file_format = File.expand_path("moviesCsvConvertidosParaOutroFormato.xlsx")
      post :create, params: { file: Rack::Test::UploadedFile.new(other_file_format, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") } 
      expect(response).to have_http_status(415)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response.body).to include("We only accept CSV files. Please verify the file type.")
    end

    it "creates a new movie" do
      uploaded_csv_file = File.expand_path("netflix_titles.csv")
      post :create, params: { file: Rack::Test::UploadedFile.new(uploaded_csv_file, "text/csv")}
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(Movie.where(title: "13 Reasons Why").exists?).to be true
      expect(response.body).to include("Movies successfully imported.")
    end
  end

  describe "validations" do
    it "requires title to be present" do
      movie = Movie.new(title: nil, genre: "Action", year: 2022, country: "USA", description: "An action-packed movie", published_at: "2022-01-01")
      expect(movie).to_not be_valid
      expect(movie.errors[:title]).to include("can't be blank")
    end

    it "requires genre to be present" do
      movie = Movie.new(title: "Test Movie", genre: nil, year: 2022, country: "USA", description: "An action-packed movie", published_at: "2022-01-01")
      expect(movie).to_not be_valid
      expect(movie.errors[:genre]).to include("can't be blank")
    end

    it "requires year to be present" do
      movie = Movie.new(title: "Test Movie", genre: "Action", year: nil, country: "USA", description: "An action-packed movie", published_at: "2022-01-01")
      expect(movie).to_not be_valid
      expect(movie.errors[:year]).to include("can't be blank")
    end

    it "requires country to be present" do
      movie = Movie.new(title: "Test Movie", genre: "Action", year: 2022, country: nil, description: "An action-packed movie", published_at: "2022-01-01")
      expect(movie).to_not be_valid
      expect(movie.errors[:country]).to include("can't be blank")
    end

    it "requires description to be present" do
      movie = Movie.new(title: "Test Movie", genre: "Action", year: 2022, country: "USA", description: nil, published_at: "2022-01-01")
      expect(movie).to_not be_valid
      expect(movie.errors[:description]).to include("can't be blank")
    end

    it "requires published_at to be present" do
      movie = Movie.new(title: "Test Movie", genre: "Action", year: 2022, country: "USA", description: "An action-packed movie", published_at: nil)
      expect(movie).to_not be_valid
      expect(movie.errors[:published_at]).to include("can't be blank")
    end

    it "requires id to be unique" do
      movie1 = Movie.create(title: "Test Movie", genre: "Action", year: 2022, country: "USA", description: "An action-packed movie", published_at: "2022-01-01")
      movie2 = Movie.new(title: "Another Test Movie", genre: "Comedy", year: 2022, country: "USA", description: "A funny movie", published_at: "2022-01-01", id: movie1.id)
      expect(movie2).to_not be_valid
      expect(movie2.errors[:id]).to include("has already been taken")
    end

    it "requires title to be unique" do
      movie1 = Movie.create(title: "Test Movie", genre: "Action", year: 2022, country: "USA", description: "An action-packed movie", published_at: "2022-01-01")
      movie2 = Movie.new(title: "Test Movie", genre: "Comedy", year: 2022, country: "USA", description: "A funny movie", published_at: "2022-01-01")
      expect(movie2).to_not be_valid
      expect(movie2.errors[:title]).to include("has already been taken")
    end
  end
end
