require "rails_helper"
require "rspec/expectations"
require "debug"

RSpec.describe Api::V1::MoviesController, type: :controller do
  describe "GET /api/v1/movies" do
    context "Unit tests to run for the query that the user submit" do
      # Testes de unidade para uma consulta que o usuário envia.
      before(:each) do
        # Criação de objetos Movie com FactoryBot.create que serão usados no testes.
        FactoryBot.create(:movie, title: "Central do Brasil", genre: "Drama", year: "1998", country: "Brazil", description: "Dora, uma amargurada ex-professora, ganha a vida escrevendo cartas para pessoas analfabetas, que ditam o que querem contar às suas famílias. Ela embolsa o dinheiro sem sequer postar as cartas. Um dia, Josué, o filho de nove anos de idade de uma de suas clientes, acaba sozinho quando a mãe é morta em um acidente de ônibus. Ela reluta em cuidar do menino, mas se junta a ele em uma viagem pelo interior do Nordeste em busca do pai de Josué, que ele nunca conheceu.", published_at: "1998-03-04") 
        FactoryBot.create(:movie, title: "Batman: The Dark Night", genre: "Action", year: "2008", country: "USA", description: "The plot follows the vigilante Batman, police lieutenant James Gordon, and district attorney Harvey Dent, who form an alliance to dismantle organized crime in Gotham City. Their efforts are derailed by the Joker, an anarchistic mastermind who seeks to test how far Batman will go to save the city from chaos.", published_at: "2008-07-18") 
      end

      it "returns movies that matches the query" do
        # O primeiro teste verifica se é retornado um filme que corresponda à consulta "Brasil". Se a resposta for bem-sucedida, o status HTTP deve ser 200, o tipo de conteúdo deve ser "application/json; charset=utf-8" e o corpo da resposta deve incluir a string "Central do Brasil".
        get :index, params: { query: "Brasil" }
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to include("Central do Brasil")
      end

      it "don't find any movie" do
        # O segundo teste verifica se uma mensagem de erro é retornada quando a consulta "La Casa de Papel" não corresponder a nenhum filme (Não foi criado nenhum filme com este título pelo FactoryBot). Assim, o status HTTP esperado é 404 e o corpo da resposta deve incluir a string "We don't find any movies with this term. Try another".
        get :index, params: { query: "La Casa de Papel" }
        expect(response).to have_http_status(404)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to include("We don't find any movies with this term. Try another")
      end

      it "don't find any movie because the query is empty" do
        # O terceiro teste verifica se uma mensagem de erro é retornada quando uma consulta vazia é enviada. O status HTTP esperado é 400 e o corpo da resposta deve incluir a string "The query that you send it was empty. Please verify.".
        get :index, params: { query: "" }
        expect(response).to have_http_status(400)
        expect(response.body).to include("The query that you send it was empty. Please verify.")
      end

      it "returns all movies if dont send any parameters" do
        # O quarto teste verifica se todos os filmes são retornados quando nenhum parâmetro é enviado. O status HTTP esperado é 200, o tipo de conteúdo deve ser "application/json; charset=utf-8" e o número de objetos retornados deve ser igual ao número total de objetos Movie criados pelo FactoryBot.
        get :index, params: {}
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body).size).to eq(Movie.all.count)
      end
    end
  end

  describe "POST /api/v1/movies" do
    context "Unit tests to run for POSTS requests that send information to storage in the API database" do
      # O código abaixo descreve uma série de testes de unidade para as requisições POST que enviam informações para armazenamento no banco de dados da API. No geral, os testes abrangem casos importantes para garantir que a API funcione corretamente ao receber e armazenar informações.
      it "no file send it" do
        # O primeiro teste verifica se nenhum arquivo é enviado, retornando um erro 400 com uma mensagem indicando que nenhum arquivo CSV foi recebido.
        post :create, params: { csv_file: nil }
        expect(response).to have_http_status(400)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to include("We don't receive any CSV file. Please check again.")
      end

      it "other file extension than csv" do
        # O segundo teste verifica se um arquivo com extensão diferente de CSV é enviado, retornando um erro 415 com uma mensagem indicando que apenas arquivos CSV são aceitos.
        other_file_format = File.expand_path("moviesCsvConvertidosParaOutroFormato.xlsx")
        post :create, params: { file: Rack::Test::UploadedFile.new(other_file_format, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") } 
        expect(response).to have_http_status(415)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to include("We only accept CSV files. Please check if are sending CSV to us.")
      end

      it "create a new movie" do
        # O terceiro teste cria um novo filme a partir de um arquivo CSV enviado, verificando se o status de resposta é 200, se a mensagem de sucesso é incluída na resposta e se o filme é adicionado ao banco de dados com sucesso.
        uploaded_csv_file = File.expand_path("netflix_titles.csv")
        post :create, params: { file: Rack::Test::UploadedFile.new(uploaded_csv_file, "text/csv")}
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(Movie.where(title: "13 Reasons Why").exists?).to be true
        expect(response.body).to include("Movies successfully imported.")
      end
    end
  end

  describe "validations" do
    context "Unit tests to verify if the validations are working" do
      # No geral, o código abaixo descreve uma série de testes de unidade para verificar se as validações definidas para o modelo "Movie" estão funcionando corretamente.
      # O teste consiste em criar instâncias do modelo "Movie" com valores nulos ou repetidos em campos obrigatórios, para então verificar se a validação impede a criação do objeto e se a mensagem de erro é a esperada. 
      # São testadas as validações de presença dos campos "title", "genre", "year", "country", "description" e "published_at", além da validação de unicidade dos campos "id" e "title".
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
        movie2 = Movie.create(title: "Another Test Movie", genre: "Comedy", year: 2022, country: "USA", description: "A funny movie", published_at: "2022-01-01")
        movie2.id = movie1.id
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
end
