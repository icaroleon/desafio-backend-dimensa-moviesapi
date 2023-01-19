Rails.application.routes.draw do
  resources :movies, only: %i[index create]
end
