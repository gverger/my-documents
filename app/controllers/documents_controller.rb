class DocumentsController < ApplicationController
  def index
    render :index, locals: { documents: indexed_documents }
  end

  def new
    render :new, locals: { document: Document.new, all_tags: all_tags }
  end

  def create
    document = Document.create!(create_params)
    document.process_file if create_params[:file]

    redirect_to documents_path, notice: "Document #{document.name} created"
  end

  def show
    document = Document.find(params[:id])
    render :show, locals: { document: document }
  end

  def edit
    render :edit, locals: { document: Document.find(params[:id]), all_tags: all_tags }
  end

  def update
    document = Document.find(params[:id])
    document.update(update_params)
    document.process_file if create_params[:file]
  end

  def destroy
    document = Document.find(params[:id])
    document.destroy

    redirect_to documents_path, notice: "Document #{document.name} deleted"
  end

  private

  def update_params
    params.require(:document).permit(:name, :description, :file, tag_ids: [])
  end

  def create_params
    params.require(:document).permit(:name, :description, :file, tag_ids: [])
  end

  def index_params
    params.permit(:search)
  end

  def all_tags
    Tag.all
  end

  def indexed_documents
    query = Document.with_attached_file.includes(:tags)
    return query unless index_params[:search].present?

    search = query.search do
      fulltext "#{index_params[:search]}~1"
    end

    search.results
  end

  def process_file

  end
end
