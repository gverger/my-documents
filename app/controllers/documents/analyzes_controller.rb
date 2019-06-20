module Documents
  class AnalyzesController < ApplicationController
    def create
      document = Document.find(document_id)
      document.process_file

      redirect_to document_path(document)
    end

    def document_id
      params[:document_id]
    end
  end
end
