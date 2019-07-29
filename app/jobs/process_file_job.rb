class ProcessFileJob < ApplicationJob
  def perform(document_id)
    document = Document.find(document_id)

    ProcessFile.new(document).call
  end
end
