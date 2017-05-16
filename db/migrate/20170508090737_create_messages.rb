class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :text
      t.boolean :is_read, default: false
      t.references :sender, index: true, foreign_key: { to_table: :profiles }
      t.references :conversation, index: true

      t.timestamps
    end
  end
end
