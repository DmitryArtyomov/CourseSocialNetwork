class CreateJoinTableProfileConversation < ActiveRecord::Migration[5.0]
  def change
    create_join_table :profiles, :conversations do |t|
      t.index [:profile_id, :conversation_id]
      t.index [:conversation_id, :profile_id]
    end
  end
end
