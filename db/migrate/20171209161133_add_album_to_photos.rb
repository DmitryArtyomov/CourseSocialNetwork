class AddAlbumToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_reference :photos, :album, foreign_key: { on_delete: :cascade }, index: true

    reversible do |dir|
      Photo.reset_column_information
      dir.up do
        Photo.all.each { |photo| photo.update_attributes(album_id: photo.profile.albums.pluck(:id).first) }
        reset_photo_counters
      end
      dir.down do
        Photo.all.each { |photo| photo.update_attributes(profile_id: photo.album.first.profile_id) }
      end
    end

    remove_reference :photos, :profile, foreign_key: { on_delete: :cascade }, index: true
  end

  def reset_photo_counters
    execute <<-SQL.squish
      UPDATE albums
      SET photos_count = (SELECT count(1) FROM photos WHERE photos.album_id = albums.id);
    SQL
  end
end
