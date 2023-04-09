class Movie < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_movie, against: %i[title genre year country published_at description], using: { tsearch: { prefix: :true } }, order_within_rank: "year DESC" # Este é um escopo de pesquisa definido no modelo Movie usando a gem pg_search. Ele permite buscar filmes pelo título, gênero, ano de lançamento, país, data de publicação e descrição. Ele usa o método pg_search_scope fornecido pela gem e configura a pesquisa para usar a estratégia tsearch com prefixo true, que permite encontrar correspondências parciais em qualquer parte da consulta de pesquisa. Além disso, a lista de resultados é ordenada em ordem decrescente de ano de lançamento.
  validates :id, :title, uniqueness: true # Validação para que tanto o id quanto o título do filme sejam únicos, evitando a criação de filmes com ids ou títulos iguais a filmes já existentes no banco de dados.
  validates :title, :genre, :year, :country, :description, :published_at, presence: true # O método validates é utilizado para validar se os atributos do objeto atendem a determinados critérios. Neste caso, o código está validando se os atributos title, genre, year, country, description e published_at estão presentes (ou seja, não nulos), utilizando o parâmetro presence: true. Essa validação garante que os dados inseridos no objeto são completos e evita erros em operações que dependem desses atributos.
  paginates_per 10 # Determina o número máximo de itens retornados por página pela Gem Kaminari.


  def to_api
    # Esse método retorna um objeto com as informações do filme no formato indicado pelo desafio.
    {
      id: id,
      title: title,
      year: year,
      genre: genre,
      country: country,
      published_at: published_at,
      description: description
    }
  end

  ### Index

  def self.all_movies(page)
    # Descrição: Retorna uma lista paginada de todos os filmes ordenados por ano de lançamento em ordem decrescente e, em caso de "empate", pelo título em ordem alfabética.
    # O retorno segue o formato especificado pelo método 'to_api'.
    # Caso o número da página seja especificado na requisição, a lista será paginada com base nesse número. Caso contrário, a página default é determinada pela configuração da Gem Kaminari ('config/initializers/kaminari_config.rb')
    Movie.all.order(year: :desc, title: :asc).page(page).map(&:to_api) #Ao ser utilizada a expressão "&:" juntamente com o metódo Map, possibilita que o bloco "to_api" é passado como argumento.
  end

  def self.search(query, page = nil)
    # Descrição: Retorna uma lista de filmes paginada que contenham o termo 'query' recebida na request.
    # Esse retorno segue o formato especificado pelo método 'to_api'.
    # Caso o número da página seja especificado na requisição, a lista será paginada com base nesse número. Caso contrário, a página default é determinada pela configuração da Gem Kaminari ('config/initializers/kaminari_config.rb'). 

    movies_search_list = Movie.search_movie(query).page(page)

    movies_search_list.map(&:to_api) # Ao ser utilizada a expressão "&:" juntamente com o metódo Map, o bloco "to_api" é passado como argumento.
  end

  ### Create

  def self.save(csv_file)
    # O método save é responsável por importar um arquivo CSV contendo informações dos filmes e salvá-los no banco de dados. Ele percorre cada linha do arquivo utilizando o método CSV.foreach e cria um novo registro da classe Movie para cada linha, passando os valores correspondentes dos campos de cada linha como argumentos. 
    # Ao final da importação, o método retorna um hash contendo a mensagem "Movies successfully imported." indicando que a operação foi realizada com sucesso.
    CSV.foreach(csv_file, headers: true) do |row|
      Movie.create({
                      title: row['title'],
                      genre: row['type'],
                      year: row['release_year'],
                      country: row['country'],
                      published_at: row['date_added'],
                      description: row['description']
                  })
    end
    { message: "Movies successfully imported." }
  end
end
