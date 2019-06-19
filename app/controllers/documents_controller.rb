class DocumentsController < ApplicationController
  def index
    render :index, locals: { documents: Document.all }
  end

  def new
    render :new, locals: { document: Document.new }
  end

  def create
    Document.create!(create_params)
  end

  def edit
    render :edit, locals: { document: Document.find(params[:id]) }
  end

  def update
    document = Document.find(params[:id])
    document.update(update_params)
  end

  private

  def update_params
    params.require(:document).permit(:name, :description, :file)
  end

  def create_params
    params.require(:document).permit(:name, :description, :file)
  end
end
