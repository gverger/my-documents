class Document < ApplicationRecord
  attribute :name, :string
  attribute :description, :text
  attribute :extracted_text, :text

  has_one_attached :file
  has_and_belongs_to_many :tags

  searchable do
    text :name, default_boost: 5
    text :description, default_boost: 2 do
      description.presence || 'NULL'
    end
    text :extracted_text do
      extracted_text.presence || 'NULL'
    end
    text :tags do
      tags.map(&:name).presence || 'NULL'
    end
  end

  def thumbnail(size)
    return nil unless file.present?

    return file.preview(resize: size) if file.previewable?

    file.variant(resize: size)
  end

  def pdf?
    file.content_type == 'application/pdf'
  end

  def process_file
    return unless file.present?

    text = pdf_text.presence || tesseract
    update(extracted_text: clean_extracted_text(text))
  end

  def clean_extracted_text(text)
    text
      .gsub(/[^[:alnum:],."'\n]/, ' ')
      .gsub(/[^\S\r\n]+/, ' ')
      .gsub(/^\s$/, '')
      .gsub(/\n+/, "\n")
      .delete("\u0000")
  end

  def pdf_text
    return unless pdf?

    file.open do |f|
      PDF::Reader.new(f).pages.map(&:text).join("\n")
    end
  end

  def tesseract
    file.open do |f|
      Tmp.dir do |dir|
        images =
          if file.content_type == 'application/pdf'
            pdf = MiniMagick::Image.new(f.path)
            pdf_dir = File.join(dir, 'pdf')
            FileUtils.mkdir_p(pdf_dir)
            pdf.pages.map.with_index do |page, index|
              page_image = File.open(File.join(pdf_dir, "page-pdf-#{index}.jpg"), 'wb')
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
          output = File.join(dir, "page-#{index}")
          `tesseract -l fra+eng #{image} #{output}`
          File.read("#{output}.txt")
        end.join("\n")
      end
    end
  end
end
