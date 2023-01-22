# **Desafio Backend Mobile2You**

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

- Primeiro é necessário executar o comando para o servidor local iniciar:
```
rails s
```

### Para criação de novos registros(**POST Request**):
1. O request deverá ser enviado para:
```
  http://localhost:3000/movies
```
2. Durante a elaboração da POST request, é necessário enviar um form-data com um file que contém os registros que deseja salvar no Banco de Dados.
   - A request ficará dessa forma:
     `
     headers => Content-Type text/csv body => file: csv_file.csv
     `
   - A título de exemplo, o POSTMAN foi utilizado. Uma HTTP request com o método POST foi criada;  O Body Content-Type selecionado foi o form-data; A KEY foi denominada como 'file'; Um arquivo .csv foi anexado como VALUE [^2]. 

### Para buscar em registros salvos (**GET Request**):

- Testes são bem-vindos.
- O filtro pode ser aplicado por 1 ou mais itens, mas devem atender aos requisitos.
- Criar um readme.md com algumas informações do projeto é sempre bem útil.
- O arquivo .csv, intitulado netflix_titles.csv, poderá ser encontrado neste repositório.


[^1]: Três respostas são possíveis: 1 - Nenhum tipo de query foi enviada; 2 - A busca encontrou registros com o termo enviado; 3 - A busca não encontrou qualquer tipo de resultado com o termo pesquisado. Todas as response se encontram formatadas em arquivo JSON. 
[^2]: Três respostas são possíveis: 1 - Não foi enviado qualquer tipo de arquivo; 2 - O arquivo enviado não é da extensão .csv; 3 - Os registros do arquivo enviado foram definitivamente salvos no banco de dados. Todas as response se encontram formatadas em arquivo JSON.
