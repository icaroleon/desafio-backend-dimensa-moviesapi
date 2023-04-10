# **Desafio Backend**

# **Desafio API**

API de serviço do catálogo de filmes para o Desafio Backend Ruby on Rails da empresa Dimensa[^1]. A API é capaz de armazenar informações sobre filmes, incluindo título, diretor, sinopse, ano de lançamento e gênero. Para isso será necessário criar dois endpoints, um que faça a leitura de um arquivo CSV e crie os registros no banco de dados. E um segundo que liste todos os filmes cadastrados em formato JSON.

### **Requisitos:**

- O desafio deve ser desenvolvido utilizando Ruby e tendo o Rails como framework.
- Poderá optar pelos bancos de dados SQLite, Postgresql ou MongoDB.
- Seguir o padrão API RESTful.
- Ordenar pelo ano de lançamento.
- Filtrar os registros por ano de lançamento, gênero, país, etc.
- Garantir que não haja duplicidade de registros.
- O projeto deve ser disponibilizado em um repositório aberto no GitHub.
- A response do endpoint de listagem deve obedecer estritamente o padrão abaixo:

```json
[
    {
        "id": "840c7cfc-cd1f-4094-9651-688457d97fa4",
        "title": "13 Reasons Why",
        "genre": "TV Show",
        "year": "2020",
        "country": "United States",
        "published_at": "2020-05-07",
        "description": "A classmate receives a series of tapes that unravel the mystery of her tragic choice."
    }
]
```

# **Resolução:**
## **Métodos da API:**

| Metódo | Descrição |
| ------------- | ------------- |
|  GET  |  Método que possibilita a busca nos registros salvos |
| POST  | Método que possibilita criar um novo registro  |

## Como acessá-los:

Para ter acesso à API na sua máquina local:

```
git clone https://github.com/icaroleon/desafio-backend-dimensa-moviesapi
cd desafio-backend-moviesapi
bundle install
```
Como a extensão 'pgcrypto' é utilizada para a geração de UUID, é necessário que esteja logado como 'SUPERUSER' no postgreSQL: 
```
1- sudo -u postgres psql // connect to postgresql
2- password = ** // adding your password
3- postgres=# \du //list of user
4- postgres=# CREATE ROLE username LOGIN SUPERUSER 'password'; //create superuser
5- postgres=# ALTER USER username WITH SUPERUSER; // Edit user role to superuser
6- migrate
```
Após estar logado como SUPERUSER, rodar o seguinte comando para criação do Banco de Dados:
```
rails db:create db:migrate
```
Após, executar o comando para o servidor local iniciar:  
```
rails s
```

### **POST Request** (Para criação de novos registros):

O request deverá ser enviado para:
  ```
  http://localhost:3000/api/v1/movies
  ```

- Durante a elaboração da POST request, é necessário enviar um form-data com um file que contém os registros que deseja salvar no Banco de Dados.
   - A request ficará dessa forma:
     `
     headers => Content-Type text/csv body => file: csv_file.csv
     `
   - A título de exemplo, o POSTMAN foi utilizado. Uma HTTP request com o método POST foi criada;  O Body Content-Type selecionado foi o form-data; A KEY foi denominada como 'file'; Um arquivo .csv foi anexado como VALUE. Após o envio, os registros são devidamente salvos no Banco de Dados. 

### **GET Request** (Para busca em registros salvos):

#### Sobre a paginação:

- A API utiliza a 'Gem Kaminari' para paginação, sendo que cada resposta fornece 10 registros por página. Não é obrigatório o envio de tais parâmetros pois a configuração da API apresenta a primeira página como default. Contudo, caso seja necessário buscar mais registros, necessário passar o parâmetro 'page' na request:

  ```
  http://localhost:3000/api/v1/movies/?page={páginaQueDeseja)
  ```

#### Para listar todos os filmes:

- Para que sejam retornados todos os filmes listados, é necessário enviar um GET request sem passar nenhum tipo de parâmetro. Como dito acima, em decorrência da implementação da paginação, caso seja necessário buscar mais registros, necessário passar o parâmetro 'page' na request. A requisição ficará dessa forma:

  ```
  http://localhost:3000/api/v1/movies # para listar todos os filmes
  http://localhost:3000/api/v1/movies/?page=2 # para ter acesso à segunda página de todos os filmes listados
  ```

#### Para pesquisas específicas:

- Para pesquisas específicas nos registros devidamente armazenados no Banco de Dados, foi utilizada a gema 'PG-Search'. O serviço fornece busca universal, logo, não é necessário diferenciar qual campo deseja pesquisar. Também, através da 'tsearch' oferecida pelo serviço, são retornados resultados similares a query recebida, não sendo necessário ser literal. Ao enviar uma query, seja relacionada ao título, gênero, ano de lançamento, descrição, a API retornará todos os resultados encontrados, organizados por ordem de lançamento. Caso ocorra "empate" entre os resultados, o "desempate" é realizado pelo título, de ordem alfabética:

  - Para tanto, é necessário enviar uma GET request para o mesmo endereço, seguida da query que deseja pesquisar. Dessa forma: 
  
    ```
    http://localhost:3000/api/v1/movies?query={termoQueDesejaPesquisar}
    http://localhost:3000/api/v1/movies/?query={termoQueDesejaPesquisar}&page={paginação} # caso deseje acessar a segunda página dos resultados fornecidos após pesquisa
    ```

## **Como testar:**

- O RSPEC foi utilzado para a criação de testes. 15 testes foram criados, são eles:
  - Quatro testes para o GET request;
  - Três testes para o POST request:
  - Oito testes para validações de registros.
    
- Para tanto, execute o comando:

```
rspec
```
### **Enjoy :D**

[^1]: Todo o código possui comentários explicando tudo que restou implementado.


