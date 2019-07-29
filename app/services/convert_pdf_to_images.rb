# frozen_string_literal: true

# Creates one image per pdf page, and puts the files into the specified directory
# under the `pdf` subdirectory
class ConvertPdfToImages
  attr_reader :pdf_file, :dir
  def initialize(pdf_file, dir)
    @pdf_file = pdf_file
    @dir = dir
  end

  def call
    pdf = MiniMagick::Image.new(pdf_file.path)
    pdf.pages.map.with_index do |page, index|
      convert_page(page, index)
    end
  end

  def pdf_dir
    @pdf_dir ||= File.join(dir, 'pdf').tap do |folder|
      FileUtils.mkdir_p(folder)
    end
  end

  def convert_page(page, index)
    page_image = File.open(File.join(pdf_dir, "page-pdf-#{index}.jpg"), 'wb')
    MiniMagick::Tool::Convert.new do |convert|
      convert.background 'white'
      convert.flatten
      convert.density 300
      convert.quality 95
      convert << page.path
      convert << page_image.path
    end

    page_image
  end
end
