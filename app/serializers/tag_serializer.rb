class TagSerializer < ActiveModel::Serializer
  attributes :text, :items_count

  def items_count
    object.taggings_count
  end
end
