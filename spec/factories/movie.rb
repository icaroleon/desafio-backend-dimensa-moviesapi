FactoryBot.define do
  factory :movie, class: Movie do
    title { "Central do Brasil" }
    genre { "Drama" }
    year { 1998 }
    country { "Brazil" }
    description { "Dora, uma amargurada ex-professora, ganha a vida escrevendo cartas para pessoas analfabetas, que ditam o que querem contar às suas famílias. Ela embolsa o dinheiro sem sequer postar as cartas. Um dia, Josué, o filho de nove anos de idade de uma de suas clientes, acaba sozinho quando a mãe é morta em um acidente de ônibus. Ela reluta em cuidar do menino, mas se junta a ele em uma viagem pelo interior do Nordeste em busca do pai de Josué, que ele nunca conheceu." }
    published_at { Date.new(1998, 3, 4) }
  end

  factory :movie2, class: Movie do
    title { "Batman: The Dark Night" }
    genre { "Action" }
    year { 2008 }
    country { "USA" }
    description { "The plot follows the vigilante Batman, police lieutenant James Gordon, and district attorney Harvey Dent, who form an alliance to dismantle organized crime in Gotham City. Their efforts are derailed by the Joker, an anarchistic mastermind who seeks to test how far Batman will go to save the city from chaos." }
    published_at { Date.new(2008, 7, 18) }
  end
end
