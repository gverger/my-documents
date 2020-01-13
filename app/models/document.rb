# frozen_string_literal: true

class Document < ApplicationRecord
  attribute :name, :string
  attribute :description, :text
  attribute :extracted_text, :text

  has_one_attached :file
  has_and_belongs_to_many :tags

  scope :active, ->(date = Date.today) { where(arel_table[:archived_on].gt(date)) }

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

  def archived_on_or_nil
    return nil if archived_on == Float::INFINITY

    archived_on
  end

  def archived_on_or_nil=(date)
    self.archived_on = Float::INFINITY if date.nil?

    self.archived_on = date
  end
end
