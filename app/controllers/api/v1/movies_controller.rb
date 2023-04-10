require 'csv'
require 'json'

class Api::V1::MoviesController < Api::V1::BaseController
  def index 
    # A função 'index' é responsável por receber as requisições GET da API juntamente com seus parâmetros, verificar se obedecem aos requisitos e renderizar respostas a tais requests.
    query = params[:query]
    page = params[:page]
    # A função começa verificando se a variável 'query' está presente como um parâmetro na requisição. Caso não esteja, a função retorna a lista completa de filmes. Em seguida, a função verifica se a variável 'query' está vazia:
    return render json: Movie.all_movies(page), status: 200 if query.nil?
    # Caso esteja vazia, a função retorna uma mensagem de erro indicando que a consulta está vazia e o código de status 400: 
    return render json: { error: "The query that you send it was empty. Please verify." }, status: 400 if query.empty?
    # Se a consulta não estiver vazia, a função verifica se há algum filme correspondente à consulta usando o método 'search' do modelo 'Movie'. Contudo, se nenhum filme correspondente for encontrado, a função retorna uma mensagem informando e o código de status 404:
    return render json: { message: "We don't find any movies with this term. Try another" }, status: 404 if Movie.search(query).empty?
    # Se houver correspondências, a função renderiza a lista de filmes correspondentes à consulta:
    render json: Movie.search(query, page)
  end

  def create
    # Esse método create recebe uma requisição POST contendo um arquivo CSV para salvar no banco de dados.
    csv_file = params[:file]
    # Primeiro verifica se um arquivo foi recebido e retorna uma resposta com status 400 caso não tenha sido enviado nenhum arquivo.
    return render json: { error: "We don't receive any CSV file. Please check again." }, status: 400 if csv_file.nil?
    # Em seguida, verifica se o arquivo é realmente do tipo CSV e retorna uma resposta com status 415 se não for.
    return render json: { error: "We only accept CSV files. Please check if are sending CSV to us." }, status: 415 if csv_file.content_type != "text/csv"
    # Por fim, chama o método save da classe Movie e retorna uma resposta JSON com uma mensagem indicando se a importação dos filmes a partir do arquivo CSV foi bem-sucedida ou não.
    render json: Movie.save(csv_file)
  end
end
