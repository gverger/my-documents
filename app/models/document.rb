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
    text = extract_text

    return unless text

    update(extracted_text: CleanText.new(text).call)
  end

  def extract_text
    return nil unless file.present?

    file.open do |f|
      return Ocr.new(f).call unless pdf?

      ExtractTextFromPdf.new(f).call
    end
  end
end
