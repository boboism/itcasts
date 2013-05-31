class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :name
      t.text :description
      t.text :notes
      t.text :html_notes
      t.datetime :published_at
      t.boolean :published
      t.integer :created_by_id
      t.integer :updated_by_id
      t.integer :published_by_id
      t.boolean :transcoded
      t.integer :transcoded_by_id
      t.datetime :transcoded_at

      t.timestamps
    end
  end
end
