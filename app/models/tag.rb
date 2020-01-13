class Tag < ApplicationRecord
  attribute :name, :string
  attribute :color, :string

  has_and_belongs_to_many :documents
end
