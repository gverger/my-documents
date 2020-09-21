# frozen_string_literal: true

class Document < ApplicationRecord
  include PgSearch::Model

  attribute :name, :string
  attribute :description, :text
  attribute :extracted_text, :text
  attribute :archived_on

  attribute :pg_search_highlight

  has_one_attached :file
  has_and_belongs_to_many :tags

  scope :active, ->(date = Date.today) { where(arel_table[:archived_on].gt(date)) }

  pg_search_scope :pg_search,
                  against: { name: 'A', description: 'B', extracted_text: 'C' },
                  using: { tsearch: { prefix: true,
                                      negation: true,
                                      highlight: {
                                        StartSel: 'PG_HIGHLIGHT_START',
                                        StopSel: 'PG_HIGHLIGHT_END',
                                        MaxWords: 8,
                                        HighlightAll: true,
                                        MaxFragments: 1
                                      } } }

  def thumbnail(size)
    return nil unless file.attached?
    return nil unless file.representable?

    file.representation(resize: size)
  end

  def pdf?
    file.attached? && file.content_type == 'application/pdf'
  end

  def archived_on_or_nil
    return nil if archived_on == Float::INFINITY

    archived_on
  end

  def archived_on_or_nil=(date)
    self.archived_on = if date.blank?
                         Float::INFINITY
                       else
                         date
                       end
  end

  def highlighted_search
    CGI
      .escapeHTML(pg_search_highlight.to_s)
      .gsub('PG_HIGHLIGHT_START', '<b class="text-gray-600">')
      .gsub('PG_HIGHLIGHT_END', '</b>')
      .html_safe
  end
end
