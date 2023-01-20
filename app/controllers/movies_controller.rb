require 'csv'

class MoviesController < ActionController::API
  def index
    query = params[:query]
    if query.empty?
      return render :json => { :error => "You don't send any query to movie search. Please check" }, :status => 400
    else 
    movies_search_list = Movie.search_movie(query) 
    movies_search_ordered_list = movies_search_list.sort_by{|key, value| key["year"]}.reverse
      if movies_search_ordered_list.empty?
        return render :json => { :error => "We don't find this term that you are looking for. Please try another." }, :status => 404
      else
        return render :json => { :results => movies_search_ordered_list }, :status => 200
      end
    end
  end

  def create  
    csv_file = params[:file]
    if csv_file.nil?
      return render :json => { :error => "We don't receive any CSV file. Please check again." }, :status => 400
    elsif csv_file.content_type != 'text/csv'
      return render :json => { :error => 'We only accept CSV files. Please check if are sending CSV to us.' }, :status => 415
    else  
      CSV.foreach(csv_file, headers: true) do |row|
        movie = Movie.create({ 
          title: row['title'],
          genre: row['type'],
          year: row['release_year'],
          country: row['country'],
          published_at: row['date_added'],
          description: row['description'] })
      end
      return render :json => { :successful => 'We just saved the CSV that you send to us. Thank you.' }, :status => 200
    end  
  end
end
