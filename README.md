# **Desafio Backend**

# **Desafio API**

Criar uma API de serviço do catálogo de filmes. Para isso será necessário criar dois endpoints, um que faça a leitura de um arquivo CSV e crie os registros no banco de dados. E um segundo que liste todos os filmes cadastrados em formato JSON.

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
|  GET  |  Método que possibilita a busca nos registros salvos [^1]  |
| POST  | Método que possibilita criar um novo registro [^2]  |

## Como acessá-los:

- Para ter acesso à API na sua máquina local:

```
git clone https://github.com/icaroleon/desafio-backend-moviesapi
cd desafio-backend-moviesapi
bundle install
```
- Como a extensão 'pgcrypto' é utilizada para a geração de UUID, é necessário que esteja logado como 'SUPERUSER' no postgreSQL: 
```
1- sudo -u postgres psql // connect to postgresql
2- password = ** // adding your password
3- postgres=# \du //list of user
4- postgres=# CREATE ROLE username LOGIN SUPERUSER 'password'; //create superuser
5- postgres=# ALTER USER username WITH SUPERUSER; // Edit user role to superuser
6- migrate
```
- Após estar logado como SUPERUSER, rodar o seguinte comando para criação do Banco de Dados:
```
rails db:create db:migrate
```
- Após, executar o comando para o servidor local iniciar:  
```
rails s
```

### Para criação de novos registros (**POST Request**):

- O request deverá ser enviado para:
```
  http://localhost:3000/api/v1/movies
```

- Durante a elaboração da POST request, é necessário enviar um form-data com um file que contém os registros que deseja salvar no Banco de Dados.
   - A request ficará dessa forma[^2]:
     `
     headers => Content-Type text/csv body => file: csv_file.csv
     `
   - A título de exemplo, o POSTMAN foi utilizado. Uma HTTP request com o método POST foi criada;  O Body Content-Type selecionado foi o form-data; A KEY foi denominada como 'file'; Um arquivo .csv foi anexado como VALUE. Após o envio, os registros são devidamente salvos no Banco de Dados. 

### Para busca em registros salvos (**GET Request**):

- Foi utilizada a gema 'PG-Search' para possibilitar a busca nos registros devidamente armazenados no Banco de Dados. O serviço fornece busca universal, logo, não é necessário diferenciar qual campo deseja pesquisar. Ao enviar uma query, seja relacionada ao título, gênero, ano de lançamento, descrição, a API retornará todos os resultados encontrados, organizados por ordem de lançamento:

- Para tanto, é necessário enviar uma GET request para o mesmo endereço, seguida da query que deseja pesquisar. Dessa forma: 
```
http://localhost:3000/api/v1/movies?query={termoQueDesejaPesquisar)
```

## **Como testar:**

- O RSPEC foi utilzado para a criação de testes. Seis testes foram criados, são eles:
  - Três testes para o GET request:
    1. Para verificar quando uma query vazia é enviada. Retorna:
    `
    Status 404 e o JSON contendo: "You don't send any query to movie search. Please check."
    `
    2. Para verificar quando uma query sem resultados é enviada. Retorna:
     `
    Status 400 e o JSON contendo: "We don't find this term that you are looking for. Please try another."
    `
    3. Para verificar quando uma query com resultados é enviada. Retorna: 
    `
    Status 200 e o JSON contendo os resultados encontrados.
    `
  - Três testes para o POST request:
    1. Para verificar quando um request é enviada sem o arquivo necessário para salvar no banco de dados. Retorna:
    `
    Status 400 e o JSON contendo: "We don't receive any CSV file. Please check again."
    `
    2. Para verificar quando um request é enviada com algum arquivo anexado que não seja do formato .csv, não sendo possível salvar no banco de dados. Retorna: 
    `
    Status 415 e o JSON contendo: "We only accept CSV files. Please check if are sending CSV to us."
    `
    3. Para verificar quando um request é enviada com um arquivo .csv, sendo possível salvar os registros no banco de dados. Retorna: 
    `
    Status 200 e o JSON contendo: "We just saved the CSV that you send to us. Thank you."
    `
    
- Para tanto, execute o comando:

```
rspec
```


### **Enjoy :D**



[^1]: Três respostas são possíveis: 1 - Nenhum tipo de query foi enviada; 2 - A busca encontrou registros com o termo enviado; 3 - A busca não encontrou qualquer tipo de resultado com o termo pesquisado. Todas as response se encontram formatadas em arquivo JSON. 
[^2]: Três respostas são possíveis: 1 - Não foi enviado qualquer tipo de arquivo; 2 - O arquivo enviado não é da extensão .csv; 3 - Os registros do arquivo enviado foram definitivamente salvos no banco de dados. Todas as response se encontram formatadas em arquivo JSON.


