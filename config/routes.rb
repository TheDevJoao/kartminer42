Rails.application.routes.draw do
  resources :racers, except: %i[new edit]
end
