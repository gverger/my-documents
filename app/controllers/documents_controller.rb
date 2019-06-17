class DocumentsController < ApplicationController
  def index
    render :index, locals: { documents: Document.all }
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
    params.require(:document).permit(:name)
  end
end
