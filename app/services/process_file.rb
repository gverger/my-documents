class ProcessFile
  attr_reader :document
  def initialize(document)
    @document = document
  end

  def call
    return if !file.present? || !text

    document.update!(extracted_text: CleanText.new(text).call)
  end

  def text
    @text ||= file.open do |f|
      return Ocr.new(f).call unless document.pdf?

      ExtractTextFromPdf.new(f).call
    end
  end

  def file
    document.file
  end
end
