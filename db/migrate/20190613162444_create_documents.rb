class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :name, null: false
      t.string :mimetype, null: false
      t.string :path, null: false

      t.timestamps
    end
  end
end
