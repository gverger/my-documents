class Document < ApplicationRecord
  attribute :name, :string
  attribute :description, :string
  has_one_attached :file
  has_and_belongs_to_many :tags

  # auto_remove is necessary for rails 6: error with `on:` when hooking otherwise
  searchable auto_remove: false do
    text :name, default_boost: 5
    text :description, default_boost: 2
    text :tags do
      tags.map(&:name)
    end
  end

  def thumbnail(size)
    return nil unless file.present?

    return file.preview(resize: size) if file.previewable?

    file.variant(resize: size)
  end
end
