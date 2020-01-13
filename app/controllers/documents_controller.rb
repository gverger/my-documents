# frozen_string_literal: true

class DocumentsController < ApplicationController
  def index
    render :index, locals: { documents: indexed_documents }
  end

  def new
    render :new, locals: { document: Document.new, all_tags: all_tags }
  end

  def create
    document = Document.create!(create_params)
    ProcessFileJob.perform_later(document.id) if create_params[:file]

    redirect_to documents_path, notice: "Document #{document.name} créé"
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
    ProcessFileJob.perform_later(document.id) if update_params[:file]

    redirect_to documents_path, notice: "Document #{document.name} mis à jour"
  end

  def destroy
    document = Document.find(params[:id])
    document.destroy

    redirect_to documents_path, notice: "Document #{document.name} supprimé"
  end

  private

  def update_params
    params.require(:document).permit(:name, :archived_on_or_nil, :description, :file, tag_ids: [])
  end

  def create_params
    params.require(:document).permit(:name, :archived_on_or_nil, :description, :file, tag_ids: [])
  end

  def index_params
    params.permit(:search)
  end

  def all_tags
    Tag.all
  end

  def indexed_documents
    query = Document.active.with_attached_file.includes(:tags)
    return query unless index_params[:search].present?

    query.pg_search(index_params[:search])
  end
end
