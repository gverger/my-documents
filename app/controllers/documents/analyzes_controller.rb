module Documents
  class AnalyzesController < ApplicationController
    def create
      ProcessFileJob.perform_later(document_id)

      redirect_to document_path(document_id)
    end

    def document_id
      params[:document_id]
    end
  end
end
