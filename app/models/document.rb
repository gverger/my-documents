class Document < ApplicationRecord
  attribute :name, :string
  attribute :mimetype, :string
  attribute :path, :string
  has_one_attached :file
end
