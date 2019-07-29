Rails.application.routes.draw do
  root 'documents#index'

  resources :documents do
    scope module: 'documents' do
      resource :analyze, only: :create
    end
  end

  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'
end
