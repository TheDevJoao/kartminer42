Rails.application.routes.draw do
  resources :racers, except: %i[new edit]
  resources :races, except: %i[new edit update]
end
