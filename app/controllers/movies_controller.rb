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
      render :json => { :error => "We don't receive a CSV file. Please check again." }, :status => 204
    elsif csv_file.content_type != 'text/csv'
      render :json => { :error => 'We only accept CSV files. Please check again.' }, :status => 415
    else  
      CSV.foreach(csv_file, headers: true) do |row|
        data = row.to_hash
        ActiveRecord::Base.transaction do
          Movie.create(data)
        end
      end
    end  
  end
end
