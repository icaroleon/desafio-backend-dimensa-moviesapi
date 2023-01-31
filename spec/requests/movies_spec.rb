require 'rails_helper'
require "rspec/expectations"
require 'debug'

RSpec.describe Api::V1::MoviesController, :type => :controller do
  describe 'GET /api/v1/movies' do
    context 'Unit tests to run for the query that the user submit' do
      before(:each) do
        FactoryBot.create(:movie, title: 'Central do Brasil', genre: 'Drama', year: '1998', country: 'Brazil', description: 'Dora, uma amargurada ex-professora, ganha a vida escrevendo cartas para pessoas analfabetas, que ditam o que querem contar às suas famílias. Ela embolsa o dinheiro sem sequer postar as cartas. Um dia, Josué, o filho de nove anos de idade de uma de suas clientes, acaba sozinho quando a mãe é morta em um acidente de ônibus. Ela reluta em cuidar do menino, mas se junta a ele em uma viagem pelo interior do Nordeste em busca do pai de Josué, que ele nunca conheceu.', published_at: '1998-03-04') 
        FactoryBot.create(:movie, title: 'Batman: The Dark Night', genre: 'Action', year: '2008', country: 'USA', description: 'The plot follows the vigilante Batman, police lieutenant James Gordon, and district attorney Harvey Dent, who form an alliance to dismantle organized crime in Gotham City. Their efforts are derailed by the Joker, an anarchistic mastermind who seeks to test how far Batman will go to save the city from chaos.', published_at: '2008-07-18') 
      end

      it 'returns all movies' do
        get :index, params: { query: 'Central do Brasil' }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to include('Central do Brasil')
        end

      it "don't find any movie" do
        get :index, params: { query: 'La Casa de Papel' }
        expect(response).to have_http_status(404)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to include("We don't find this term that you are looking for. Please try another.")
      end

      it "don't find any movie" do
        get :index, params: { query: '' }

        expect(response).to have_http_status(400)
        expect(response.body).to include("You don't send any query to movie search. Please check")
      end
    end
  end

  describe 'POST /api/v1/movies' do
    context 'Unit tests to run for POSTS requests that send information to storage in the API database' do
      before(:each) do
        headers = ["Title", "Genre", "Year", "Country", "Description", "published_at"]
        first_row = ['Central do Brasil', 'Drama', '1998', 'Brazil', 'Dora, uma amargurada ex-professora, ganha a vida escrevendo cartas para pessoas analfabetas, que ditam o que querem contar às suas famílias. Ela embolsa o dinheiro sem sequer postar as cartas. Um dia, Josué, o filho de nove anos de idade de uma de suas clientes, acaba sozinho quando a mãe é morta em um acidente de ônibus. Ela reluta em cuidar do menino, mas se junta a ele em uma viagem pelo interior do Nordeste em busca do pai de Josué, que ele nunca conheceu.', '1998-03-04']
        second_row = ['Batman: The Dark Night', 'Action', '2008', 'USA', 'The plot follows the vigilante Batman, police lieutenant James Gordon, and district attorney Harvey Dent, who form an alliance to dismantle organized crime in Gotham City. Their efforts are derailed by the Joker, an anarchistic mastermind who seeks to test how far Batman will go to save the city from chaos.', '2008-07-18']

       CSV.open('movies_test.csv', 'w') do |csv|
          csv << headers
          csv << first_row
          csv << second_row
        end
      end

      after(:each) do
        File.delete('movies_test.csv')
      end

      it 'no file send it' do
        post :create, params: { "Content-Type" => nil }

        expect(response).to have_http_status(400)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to include("We don't receive any CSV file. Please check again.")
      end

      it 'other file extension than csv' do
        other_file_format = File.expand_path('/home/icleon/code/icaroleon/tarefas/desafio-backend-dimensa-moviesapi/moviesCsvConvertidosParaOutroFormato.xlsx')
        post :create, params: {:file => Rack::Test::UploadedFile.new(other_file_format, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')} 

        expect(response).to have_http_status(415)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to include("We only accept CSV files. Please check if are sending CSV to us.")
      end

      it 'create a new movie' do
        post :create, params: {:file => Rack::Test::UploadedFile.new('movies_test.csv', 'text/csv')}

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to include("We just saved the CSV that you send to us. Thank you.")
      end
    end
  end
end
