class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :type
      t.integer :assetable_id
      t.string :assetable_type
      t.attachment :archive
      t.timestamps
    end
  end
end
