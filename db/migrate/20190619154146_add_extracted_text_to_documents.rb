class AddExtractedTextToDocuments < ActiveRecord::Migration[6.0]
  def change
    change_table :documents do |t|
      t.text :extracted_text
    end
  end
end
