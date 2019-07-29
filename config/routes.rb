# frozen_string_literal: true

Rails.application.routes.draw do
  root 'documents#index'

  resources :documents do
    scope module: 'documents' do
      resource :analyze, only: :create
    end
  end

  resource :login, controller: 'login', only: %i[new]

  mount PdfjsViewer::Rails::Engine => '/pdfjs', as: 'pdfjs'

  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback'
  get 'oauth/disconnect' => 'oauths#disconnect'

  if Rails.env.development?
    get 'autologin', to: 'oauths#autologin', as: :auth_at_provider
  else
    get 'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider
  end
end
