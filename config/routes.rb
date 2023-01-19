Rails.application.routes.draw do
  resources :movies, only: %i[index create]
  get "/movies/search", to: "movies#index" 
end
