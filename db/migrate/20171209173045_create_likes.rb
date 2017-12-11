class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.references :profile, foreign_key: true
      t.references :likeable, polymorphic: true, index: true
    end
  end
end
