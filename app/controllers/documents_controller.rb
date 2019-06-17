class DocumentsController < ApplicationController
  def index
    render :index, locals: { documents: Document.all }
  end
end
