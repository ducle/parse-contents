class CreateSiteContents < ActiveRecord::Migration[5.0]
  def change
    create_table :site_contents do |t|
      t.integer :site_id, null: false
      t.string :tag_name
      t.string :content

      t.timestamps
    end
    add_index :site_contents, :site_id
  end
end
