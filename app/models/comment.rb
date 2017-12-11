# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  text             :string
#  profile_id       :integer
#  commentable_type :string
#  commentable_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_profile_id                           (profile_id)
#

class Comment < ApplicationRecord
  belongs_to :profile
  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count

  has_many :likes, as: :likeable, dependent: :destroy

  validates :text, presence: true, length: { maximum: 140 }

  COMMENTABLE_TYPES = [
    :photo
  ].freeze

  def self.valid_commentable_type?(string_to_test)
    COMMENTABLE_TYPES.include? string_to_test.gsub(/\s+/, '_').downcase.to_sym
  end
end
