class CreateMusics < ActiveRecord::Migration[6.1]
  def change
    create_table :musics do |t|
      t.string :name
      t.string :href
      t.string :id_spotify
      t.integer :time
      t.boolean :sounded, default: false
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
