class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps
    end

    create_table :tags do |t|
      t.string :name, null: false
      t.string :color, null: false, default: 'white'

      t.timestamps
    end

    create_join_table :documents, :tags do |t|
      t.index :document_id
      t.index :tag_id

      t.timestamps
    end
  end
end
