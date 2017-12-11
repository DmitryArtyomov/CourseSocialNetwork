class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :text
      t.references :profile, foreign_key: { on_delete: :cascade }, index: true
      t.references :commentable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
