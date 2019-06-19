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
    return if file.content_type != 'application/pdf'

    file.open do |f|
      update(extracted_text: PDF::Reader.new(f).pages.map(&:text).join("\n"))
    end
  end
end
