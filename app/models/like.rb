# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  profile_id    :integer
#  likeable_type :string
#  likeable_id   :integer
#
# Indexes
#
#  index_likes_on_likeable_type_and_likeable_id  (likeable_type,likeable_id)
#  index_likes_on_profile_id                     (profile_id)
#

class Like < ApplicationRecord
  belongs_to :profile
  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count

  LIKEABLE_TYPES = [
    :photo
  ].freeze

  def self.valid_likeable_type?(string_to_test)
    LIKEABLE_TYPES.include? string_to_test.gsub(/\s+/, '_').downcase.to_sym
  end
end
