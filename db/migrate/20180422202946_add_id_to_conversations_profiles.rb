class AddIdToConversationsProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations_profiles, :id, :primary_key
  end
end
