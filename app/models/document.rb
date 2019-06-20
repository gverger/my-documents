class Document < ApplicationRecord
  attribute :name, :string
  attribute :description, :text
  attribute :extracted_text, :text

  has_one_attached :file
  has_and_belongs_to_many :tags

  # auto_remove is necessary for rails 6: error with `on:` when hooking otherwise
  searchable auto_remove: false do
    text :name, default_boost: 5
    text :description, default_boost: 2
    text :extracted_text
    text :tags do
      tags.map(&:name)
    end
  end

  def thumbnail(size)
    return nil unless file.present?

    return file.preview(resize: size) if file.previewable?

    file.variant(resize: size)
  end

  def process_file
    return unless file.present?

    text = pdf_text.presence || tesseract
    update(extracted_text: text)
  end

  def pdf_text
    return if file.content_type != 'application/pdf'

    file.open do |f|
      PDF::Reader.new(f).pages.map(&:text).join("\n")
    end
  end

  def tesseract
    file.open do |f|
      images =
        if file.content_type == 'application/pdf'
          pdf = MiniMagick::Image.new(f.path)
          pdf.pages.map.with_index do |page, index|
            page_image = File.open("/tmp/page-pdf-#{index}.jpg", 'wb')
            MiniMagick::Tool::Convert.new do |convert|
              convert.background 'white'
              convert.flatten
              convert.density 300
              convert.quality 95
              convert << page.path
              convert << page_image.path
            end

            page_image.path
          end
        else
          [f.path]
        end
      images.flat_map.with_index do |image, index|
        `tesseract -l fra+eng #{image} /tmp/page-#{index}`
        File.read("/tmp/page-#{index}.txt")
            .gsub(/[^[:alnum:],."'\n]/, ' ')
            .gsub(/[^\S\r\n]+/, ' ')
            .gsub(/^\s$/, '')
            .gsub(/\n+/, "\n")
      end.join("\n")
    end
  end
end
