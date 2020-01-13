# frozen_string_literal: true

class AddArchivedOnToDocuments < ActiveRecord::Migration[6.0]
  def change
    change_table :documents do |t|
      t.date :archived_on, null: false, default: Float::INFINITY
    end
  end
end
