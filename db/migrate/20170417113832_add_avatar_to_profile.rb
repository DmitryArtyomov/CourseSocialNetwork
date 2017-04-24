class AddAvatarToProfile < ActiveRecord::Migration[5.0]
  def change
    add_reference :profiles, :avatar, references: :photos, index: true
    add_foreign_key :profiles, :photos, column: :avatar_id, on_delete: :nullify
  end
end
