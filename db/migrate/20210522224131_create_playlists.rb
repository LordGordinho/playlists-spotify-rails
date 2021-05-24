class CreatePlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :playlists do |t|
      t.string :name
      t.string :image_url
      t.boolean :public
      t.references :user, null: false, foreign_key: true
      t.string :owner
      t.string :href
      t.string :uri
      t.string :path
      t.string :id_spotify

      t.timestamps
    end
  end
end
