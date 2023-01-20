require 'rails_helper'
require 'debug'
require 'rack/test'


RSpec.describe MoviesController, :type => :controller do

  describe 'GET /movies' do 
    before(:each) do
        FactoryBot.create(:movie, title: 'Central do Brasil', genre: 'Drama', year: '1998', country: 'Brazil', description: 'Dora, uma amargurada ex-professora, ganha a vida escrevendo cartas para pessoas analfabetas, que ditam o que querem contar às suas famílias. Ela embolsa o dinheiro sem sequer postar as cartas. Um dia, Josué, o filho de nove anos de idade de uma de suas clientes, acaba sozinho quando a mãe é morta em um acidente de ônibus. Ela reluta em cuidar do menino, mas se junta a ele em uma viagem pelo interior do Nordeste em busca do pai de Josué, que ele nunca conheceu.', published_at: '1998-03-04') 
        FactoryBot.create(:movie, title: 'Central do Brasil lero', genre: 'Drama2', year: '1992', country: 'Brazil2', description: '222Dora, uma amargurada ex-professora, ganha a vida escrevendo cartas para pessoas analfabetas, que ditam o que querem contar às suas famílias. Ela embolsa o dinheiro sem sequer postar as cartas. Um dia, Josué, o filho de nove anos de idade de uma de suas clientes, acaba sozinho quando a mãe é morta em um acidente de ônibus. Ela reluta em cuidar do menino, mas se junta a ele em uma viagem pelo interior do Nordeste em busca do pai de Josué, que ele nunca conheceu.', published_at: '1998-03-04') 
      end

    it 'returns all movies' do
      get :index, params: { query: 'Central do Brasil' }

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response.body).to include('Central do Brasil')
    end

    it "don't find any movie" do
      get :index, params: { query: 'La Casa de Papel' }

      expect(response).to have_http_status(404)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response.body).to include("We don't find this term that you are looking for. Please try another.")
    end

    it "don't find any movie" do
      get :index, params: { query: '' }
      
      expect(response).to have_http_status(400)
      expect(response.body).to include("You don't send any query to movie search. Please check")
    end 
  end     

describe 'POST /movies' do
    it 'no file send it' do
      post :create, :params => { "Content-Type" => be_nil } 
      
      expect(response).to have_http_status(400)
      expect(response.body).to include("We don't receive any CSV file. Please check again.")
    end
    
    it 'other extension file than csv' do
      post :create, :params => { "Content-Type" => 'application/json' }
    
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(415)
    end
  
    it 'create a new movie' do     
      post :create, as: :csv, :params => { :movie => { :title => 'Central do Brasil3', :genre => 'Drama3', :year => '1993', :country => 'Brazil3', :description => 'Dora3, uma amargurada ex-professora, ganha a vida escrevendo cartas para pessoas analfabetas, que ditam o que querem contar às suas famílias. Ela embolsa o dinheiro sem sequer postar as cartas. Um dia, Josué, o filho de nove anos de idade de uma de suas clientes, acaba sozinho quando a mãe é morta em um acidente de ônibus. Ela reluta em cuidar do menino, mas se junta a ele em uma viagem pelo interior do Nordeste em busca do pai de Josué, que ele nunca conheceu.', :published_at => '1998-03-04' } }
        
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(200)
    end
  end
end
