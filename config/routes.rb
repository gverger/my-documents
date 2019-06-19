Rails.application.routes.draw do
  root 'documents#index'

  resources :documents, only: %i[index edit update new create]
end
