Rails.application.routes.draw do
  namespace :api, defaults: { format: :json} do
    namespace :v1 do
      get "/movies/query", to: "movies#index" 

    resources :movies, only: %i[index create]
    end
  end
end
