# == Schema Information
#
# Table name: taggings
#
#  tag_id        :integer
#  taggable_type :string
#  taggable_id   :integer
#  id            :integer          not null, primary key
#
# Indexes
#
#  index_taggings_on_tag_id                                    (tag_id)
#  index_taggings_on_tag_id_and_taggable_id_and_taggable_type  (tag_id,taggable_id,taggable_type) UNIQUE
#  index_taggings_on_taggable_type_and_taggable_id             (taggable_type,taggable_id)
#

class Tagging < ApplicationRecord
  belongs_to :tag, counter_cache: true
  belongs_to :taggable, polymorphic: true

  validates :tag_id, uniqueness: { scope: [:taggable_id, :taggable_type] }
end
