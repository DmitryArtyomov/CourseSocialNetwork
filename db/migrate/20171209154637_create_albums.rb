class CreateAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :is_main, default: false
      t.references :profile, foreign_key: { on_delete: :cascade }
      t.integer :photos_count, default: 0

      t.timestamps
    end

    reversible do |dir|
      Album.reset_column_information
      dir.up do
        User.all.each { |user| UsersConfirmService.new(user).execute }
      end
      dir.down do
        Album.destroy_all
      end
    end
  end
end
