class AddForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :conversations_profiles, :conversations, on_delete: :cascade
    add_foreign_key :conversations_profiles, :profiles, on_delete: :cascade
    add_foreign_key :messages, :conversations, on_delete: :cascade
    add_foreign_key :photos, :albums, on_delete: :cascade
  end
end
