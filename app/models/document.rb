class Document < ApplicationRecord
  attribute :name, :string
  attribute :description, :string
  has_one_attached :file
  has_and_belongs_to_many :tags

  def thumbnail(size)
    return nil if file.nil?
    return file.preview(resize: size) if file.previewable?
    return file.variant(resize: size)
  end
end
