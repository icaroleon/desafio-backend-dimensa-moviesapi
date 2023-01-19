require 'csv'
require 'securerandom'

class MoviesController < ActionController::API
  def index
    render json: { check: 'Nice' }
  end

  def create  
    csv_file = params[:file]
    new_id = SecureRandom.uuid
    
    if csv_file.nil?
<<<<<<< HEAD
      return render :json => { :error => "We don't receive an CSV file. Please check again." }, :status => 200
    elsif csv_file.content_type != 'text/csv'
      return render :json => { :error => 'We only accept CSV files. Please check again.' }, :status => 415
    else  
      CSV.foreach(csv_file, headers: true) do |row|
        movie = Movie.create({ 
          title: row['title'],
          genre: row['type'],
          year: row['release_year'],
          country: row['country'],
          published_at: row['date_added'],
          description: row['description'] })
        movie.save
        return render :json => { :successful => 'We just saved the CSV that you send to us. Thank you.' }, :status => 200
=======
      render :json => { :error => "We don't receive a CSV file. Please check again." }, :status => 204
    elsif csv_file.content_type != 'text/csv'
      render :json => { :error => 'We only accept CSV files. Please check again.' }, :status => 415
    else  
      CSV.foreach(csv_file, headers: true) do |row|
        data = row.to_hash
        ActiveRecord::Base.transaction do
          Movie.create(data)
        end
>>>>>>> 289ba9c96ad6475b7d794e8f85ad1f3dfb3ec017
      end
    end  
  end
end
