class AddIdToTaggings < ActiveRecord::Migration[5.0]
  def change
    add_column :taggings, :id, :primary_key
  end
end
