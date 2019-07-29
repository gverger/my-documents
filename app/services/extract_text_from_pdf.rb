class ExtractTextFromPdf
  attr_reader :file
  def initialize(file)
    @file = file
  end

  def call
    pdf_text.presence || tesseract
  end

  def pdf_text
    PDF::Reader.new(file).pages.map(&:text).join("\n")
  rescue
    nil
  end

  def tesseract
    Tmp.dir do |dir|
      images = ConvertPdfToImages.new(file, dir).call
      images.flat_map do |image|
        Ocr.new(image).call
      end.join("\n")
    end
  end
end
