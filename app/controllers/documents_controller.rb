class DocumentsController < ApplicationController
  def index
    render :index, locals: { documents: Document.all.with_attached_file.includes(:tags) }
  end

  def new
    render :new, locals: { document: Document.new, all_tags: all_tags }
  end

  def create
    Document.create!(create_params)
  end

  def edit
    render :edit, locals: { document: Document.find(params[:id]), all_tags: all_tags }
  end

  def update
    document = Document.find(params[:id])
    document.update(update_params)
  end

  private

  def update_params
    params.require(:document).permit(:name, :description, :file, tag_ids: [])
  end

  def create_params
    params.require(:document).permit(:name, :description, :file, tag_ids: [])
  end

  def all_tags
    Tag.all
  end
end
