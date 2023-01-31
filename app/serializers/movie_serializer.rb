# ActiveModel Serializer - Serve para gerar os atributos que serão repassados durante a criação do JSON;

class MovieSerializer < ActiveModel::Serializer
  attributes %i[id title genre year country published_at description]
end
