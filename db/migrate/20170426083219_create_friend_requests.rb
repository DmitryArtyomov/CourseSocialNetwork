class CreateFriendRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :friend_requests do |t|
      t.references :sender, references: :profiles
      t.references :recipient, references: :profiles
      t.integer :status, default: 0

      t.timestamps
    end

    add_foreign_key :friend_requests, :profiles, column: :sender_id,    on_delete: :cascade
    add_foreign_key :friend_requests, :profiles, column: :recipient_id, on_delete: :cascade

    add_index :friend_requests, [:sender_id, :status]
    add_index :friend_requests, [:recipient_id, :status]
  end
end
